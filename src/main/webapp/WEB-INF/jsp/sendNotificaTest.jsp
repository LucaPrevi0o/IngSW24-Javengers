<%@ page import="it.unife.ingsw2024.models.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% var user=(User)request.getAttribute("user"); %>
<!DOCTYPE html>
<html>
    <head>
        <title>Send notifica - @<%= user.getUsername() %></title>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.4.0/sockjs.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
        <script type="text/javascript">
            var stompClient = null;

            var msg=document.querySelector("#message").value;
            var socket = new SockJS('/ws');
            stompClient = Stomp.over(socket);
            stompClient.connect({}, function(frame) {
                console.log(frame);
            });

            function sendMessage() {
                var title = "Nuova notifica";
                stompClient.send('/app/application', {}, JSON.stringify({

                    srcUser: "@<%= user.getUsername() %>", //username of user that sends notification
                    title: title, //notification title
                    text: msg })) //notification text
            }
        </script>
    </head>
    <body>
        <section class="content">
            <p>Send notification as user <%= user.getId() %> (@<%= user.getUsername() %>)</p>
            <label for="message">Insert message here: </label>
            <input type="text" placeholder="Insert message..." id="message">
            <button onclick="sendMessage()">Send message</button>
        </section>
    </body>
</html>