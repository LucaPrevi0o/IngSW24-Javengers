<%@ page import="it.unife.ingsw2024.models.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String titoloSidebar = "Profilo utente";
    var user=(User)request.getAttribute("user");
    var selectedUser=(User)request.getAttribute("selectedUser");
    var followerList=(List<User>)request.getAttribute("followerList");
    var followedList=(List<User>)request.getAttribute("followedList");
 %>
<!DOCTYPE html>
<html>
    <head>
        <title>Profilo di @<%= selectedUser.getUsername()%> - @<%= user.getUsername() %></title>
        <link rel="stylesheet" href="../../css/following.css" type="text/css" media="screen">
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
                var now = new Date();
                var date = now.toLocaleDateString('en-CA');
                let time = now.toLocaleTimeString('en-GB');

                stompClient.send('/app/application/' + <%= selectedUser.getId() %>, {}, JSON.stringify({

                    usernameSrc: "<%= user.getUsername() %>", //username of user that sends notification
                    userSrcId: <%= user.getId() %>,
                    notificationDate: date,
                    notificationTime: time,
                    notificationType: 1,
                    title: title, //notification title
                    notificationMsg: "@<b><%= user.getUsername() %></b> ha cominciato a seguirti" })) //notification text
            }

            function sendNotifica(){
                sendMessage();
            }

        </script>
    </head>
    <body>
        <%@include file="../include/sidebar.jsp"%>
        <section class="content">
            <%@include file="../include/notif-bell.jsp"%>
            <%@include file="../include/notif-push.jsp"%>
            <div class="container">
                <section class="utente-container">
                    <img id="propic" src="../../images/propic.jpg" alt="Profile picture" width="60" height="60"/>
                    <span>@<%= selectedUser.getUsername() %></span>
                </section>
                <section class="following-container">
                    <section class="followers">
                        <div class="followers-header">
                            <h2>Followers</h2>
                            <span><%= followerList.size() %></span>
                        </div>
                        <div class="list-container">
                            <div class="followers-list">
                                <% for (var f: followerList) { %>
                                    <a href="<%= request.getContextPath() %>/following?id=<%= f.getId() %>&loggedId=<%= user.getId() %>"><p>@<b><%= f.getUsername() %></b></p></a>
                                <% } %>
                            </div>
                        </div>
                    </section>
                    <section class="followed">
                        <div class="followers-header">
                            <h2>Following</h2>
                            <span><%= followedList.size() %></span>
                        </div>
                        <div class="list-container" style="">
                            <div class="followers-list">
                                <% for (var f: followedList) { %>
                                    <a href="<%= request.getContextPath() %>/following?id=<%= f.getId() %>&loggedId=<%= user.getId() %>"><p>@<b><%= f.getUsername() %></b></p></a>
                                <% } %>
                            </div>
                        </div>
                    </section>
                </section>
                <% if (user.getId()!=selectedUser.getId()) { %>
                <%-- Se l'id dell'utente loggato è presente nella lista di followers dell'utente allora viene visualizzato il pulsante "Smetti di seguire", altrimenti il pulsante segui --%>
                <% if (followerList.stream().filter(item -> item.getId() == loggedUser.getId()).findAny().orElse(null) != null) {%><a href="<%= request.getContextPath() %>/unfollow?id=<%= user.getId() %>&followedId=<%= selectedUser.getId() %>"><button class="segui-button">Smetti di seguire</button></a>
                <%} else {%>
                <a href="<%= request.getContextPath() %>/follow?id=<%= user.getId() %>&followedId=<%= selectedUser.getId() %>"><button onclick="sendNotifica()" class="segui-button">Segui</button></a>
                <% }} %>
                <a href="<%= request.getContextPath() %>/block?blockedId=<%= selectedUser.getId() %>&userId=<%= user.getId() %>"><button id="block">Blocca utente</button></a>
            </div>
        </section>
    </body>
</html>