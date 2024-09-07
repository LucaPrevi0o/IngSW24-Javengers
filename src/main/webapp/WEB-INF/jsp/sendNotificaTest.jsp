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

            var socket = new SockJS('/ws');
            stompClient = Stomp.over(socket);
            stompClient.connect({}, function(frame) {
                console.log(frame);
            });

            function sendMessage() {
                var title = "Nuova notifica";
                var userId=document.querySelector("#userId").value;
                var type=document.querySelector("#notifType").value;
                var msg=document.querySelector("#message").value;
                var now = new Date();
                var date = now.toLocaleDateString('en-CA');
                let time = now.toLocaleTimeString('en-GB');

                stompClient.send('/app/application/' + userId, {}, JSON.stringify({

                    usernameSrc: "<%= user.getUsername() %>", //username of user that sends notification
                    userSrcId: <%= user.getId() %>,
                    notificationDate: date,
                    notificationTime: time,
                    notificationType: type,
                    title: title, //notification title
                    notificationMsg: msg })) //notification text
            }
        </script>
    </head>
    <body>
        <section class="content">
            <p>Send notification as user <%= user.getId() %> (@<%= user.getUsername() %>)</p>
            <label for="userId">Insert the destination user id here: </label>
            <input type="number" placeholder="Insert user id..." id="userId"><br/>
            <label for="notifType">Select notification type</label>
            <select id="notifType">
                <option value="0">Messaggi</option>
                <option value="1">Follower</option>
                <option value="2">Eventi</option>
                <option value="3">Pagamenti</option>
            </select><br/>
            <label for="message">Insert message here: </label>
            <input type="text" placeholder="Insert message..." id="message"><br/><br/>
            <button onclick="sendMessage()">Send notification</button>
        </section>
    </body>
</html>