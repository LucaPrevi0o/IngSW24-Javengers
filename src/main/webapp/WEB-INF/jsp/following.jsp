<%@ page import="it.unife.ingsw2024.models.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    var titoloSidebar = "Profilo utente";
    var user=(User)request.getAttribute("user");
    var selectedUser=(User)request.getAttribute("selectedUser");
    var followerList=(List<User>)request.getAttribute("followerList");
    var followedList=(List<User>)request.getAttribute("followedList");
    var blockedUsers=(List<User>)request.getAttribute("blockedUsers");
 %>
<!DOCTYPE html>
<html>
    <head>
        <title>Profilo di @<%= selectedUser.getUsername()%> - @<%= user.getUsername() %></title>
        <link rel="stylesheet" href="../../css/following.css" type="text/css" media="screen">
    </head>
    <body>
        <%@include file="../include/sidebar.jsp"%>
        <section class="content">
            <%@include file="../include/notif-bell.jsp"%>
            <%@include file="../include/notif-push.jsp"%>
            <div class="container">
                <%-- Sezione con username e immagine profilo dell'utente --%>
                <section class="utente-container">
                    <img id="propic" src="../../images/propic.jpg" alt="Profile picture" width="60" height="60"/>
                    <span>@<%= selectedUser.getUsername() %></span>
                </section>
                    <%-- Sezione con numero di utenti followers/following --%>
                <section class="following-container">
                    <section class="followers">
                        <div class="followers-header">
                            <h2>Followers</h2>
                            <span><%= followerList.size() %></span>
                        </div>
                        <div class="list-container">
                            <%-- Lista di utenti che seguono l'utente selezionato --%>
                            <div class="followers-list">
                                <% for (var f: followerList) { %>
                                    <%-- Ogni username ha un link che porta al profilo corrispondente --%>
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
                        <div class="list-container">
                            <%-- Lista di utenti che l'utente selezionato segue --%>
                            <div class="followers-list">
                                <% for (var f: followedList) { %>
                                    <%-- Ogni username ha un link che porta al profilo corrispondente --%>
                                    <a href="<%= request.getContextPath() %>/following?id=<%= f.getId() %>&loggedId=<%= user.getId() %>"><p>@<b><%= f.getUsername() %></b></p></a>
                                <% } %>
                            </div>
                        </div>
                    </section>
                </section>
                <div id="buttons-container">
                    <% if (user.getId()!=selectedUser.getId()) { %>
                    <%-- Se l'id dell'utente loggato è presente nella lista di followers dell'utente allora viene visualizzato il pulsante "Smetti di seguire", altrimenti il pulsante "Segui" --%>
                    <% if (followerList.stream().filter(item -> item.getId() == user.getId()).findAny().orElse(null) != null) {%>
                    <a href="<%= request.getContextPath() %>/unfollow?id=<%= user.getId() %>&followedId=<%= selectedUser.getId() %>"><button class="segui-button">Smetti di seguire</button></a>
                    <%} else {%>
                    <a href="<%= request.getContextPath() %>/follow?id=<%= user.getId() %>&followedId=<%= selectedUser.getId() %>"><button class="segui-button">Segui</button></a>
                    <% } %>
                    <%-- Se l'id dell'utente di questo profilo è presente nella lista di utenti bloccati dell'utente allora viene visualizzato il pulsante "Sblocca utente", altrimenti il pulsante "Blocca utente" --%>
                    <% if (blockedUsers.stream().filter(item -> item.getId() == selectedUser.getId()).findAny().orElse(null) != null) {%>
                    <a href="<%= request.getContextPath() %>/unblock?blockedId=<%= selectedUser.getId() %>&userId=<%= user.getId() %>"><button class="block-button">Sblocca utente</button></a>
                    <%} else {%>
                    <a href="<%= request.getContextPath() %>/block?blockedId=<%= selectedUser.getId() %>&userId=<%= user.getId() %>"><button class="block-button">Blocca utente</button></a>
                    <%}}%>
                </div>
            </div>
        </section>
    </body>
</html>