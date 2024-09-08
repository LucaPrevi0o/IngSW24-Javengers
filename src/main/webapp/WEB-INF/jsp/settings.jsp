<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% var activeUser=(User)request.getAttribute("user"); %>
<%
    var blockedUsers=(List<User>)request.getAttribute("blockedUsers");
    String titoloSidebar = "Impostazioni";
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Impostazioni</title>
        <link rel="stylesheet" href="../../css/settings.css" type="text/css" media="screen">
    </head>
    <body>
        <%@include file="../include/sidebar.jsp"%>
        <section class="content">
            <%@include file="../include/notif-bell.jsp"%>
            <%@include file="../include/notif-push.jsp"%>
            <h1>Impostazioni del profilo</h1>
            <div id="settings-container">
                <section id="blocked-users-settings">
                    <h2><label for="blocked_users_list">Lista utenti bloccati</label></h2>
                    <ul id="blocked_users_list">
                        <% for (var user: blockedUsers) { %>
                            <li>
                                <a href="<%= request.getContextPath() %>/following?id=<%= user.getId() %>&loggedId=<%= activeUser.getId() %>">@<b><%= user.getUsername() %></b></a>
                                <a href="<%= request.getContextPath() %>/unblock?blockedId=<%= user.getId() %>&userId=<%= activeUser.getId() %>"><button class="unblock-button">Sblocca utente</button></a>
                            </li>
                        <% } %>
                    </ul>
                </section>
                <section id="notif-settings">
                    <h2>Preferenze notifiche</h2>
                    <div id="notif-settings-container">
                        <p>Selezionare le categorie di notifiche da ricevere</p>
                        <div class="notif-settings-option">
                            <input type="checkbox" id="message_notif">
                            <label for="message_notif">Messaggi</label>
                        </div>
                        <div class="notif-settings-option">
                            <input type="checkbox" id="follower_notif">
                            <label for="follower_notif">Follower</label>
                        </div>
                        <div class="notif-settings-option">
                            <input type="checkbox" id="event_notif">
                            <label for="event_notif">Eventi</label>
                        </div>
                        <div class="notif-settings-option">
                            <input type="checkbox" id="payment_notif">
                            <label for="payment_notif">Pagamenti</label>
                        </div>
                    </div>
                </section>
            </div>
        </section>
    </body>
</html>