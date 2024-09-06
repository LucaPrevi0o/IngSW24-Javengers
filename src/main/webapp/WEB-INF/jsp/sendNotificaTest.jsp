<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Send notifica</title>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.4.0/sockjs.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
        <script type="text/javascript">
            var stompClient = null;

            var socket = new SockJS('/ws');
            stompClient = Stomp.over(socket);
            stompClient.connect({}, function(frame) {
                console.log(frame);
            });

            function sendMessage() {
                var text = "testo messaggio"
                stompClient.send('/app/application', {}, JSON.stringify({ from: "from", text: text }))
            }
        </script>
    </head>
    <body>
        <section class="content">
            <button onclick="sendMessage()">Send message</button>
        </section>
    </body>
</html>