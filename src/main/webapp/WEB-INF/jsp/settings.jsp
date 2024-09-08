<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% var activeUser=(User)request.getAttribute("user"); %>
<% var blockedUsers=(List<User>)request.getAttribute("blockedUsers"); %>
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
            <h1>Impostazioni profilo</h1>
            <h2><label for="blocked_users_list">Lista utenti bloccati</label></h2>
            <ul id="blocked_users_list">
                <% for (var user: blockedUsers) { %>
                    <li>
                        <a href="<%= request.getContextPath() %>/following?id=<%= user.getId() %>&loggedId=<%= activeUser.getId() %>">@<b style="color: brown"><%= user.getUsername() %></b></a>
                        <button>Sblocca utente</button>
                    </li>
                <% } %>
            </ul>
            <hr/>
            <h2>Preferenze notifiche</h2>
            <p>Selezionare le categorie di notifiche da ricevere</p>
            <label for="message_notif">Messaggi</label>
            <input type="checkbox" id="message_notif"><br/>
            <label for="follower_notif">Follower</label>
            <input type="checkbox" id="follower_notif"><br/>
            <label for="event_notif">Eventi</label>
            <input type="checkbox" id="event_notif"><br/>
            <label for="payment_notif">Pagamenti</label>
            <input type="checkbox" id="payment_notif">
        </section>
    </body>
</html>