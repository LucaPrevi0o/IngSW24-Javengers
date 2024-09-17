<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% var activeUser=(User)request.getAttribute("user"); %>
<%
    var titoloSidebar = "Impostazioni";
    var blockedUsers=(List<User>)request.getAttribute("blockedUsers");
    var userPreferences=(boolean[])request.getAttribute("userPreferences");

%>
<!DOCTYPE html>
<html>
    <head>
        <title>Impostazioni</title>
        <link rel="stylesheet" href="../../css/settings.css" type="text/css" media="screen">
        <script>
            function updatePreferences() {

                //Seleziona i valori relativi alle preferenze utente dalle checkbox
                let messages=document.querySelector("#message_notif").checked;
                let followers=document.querySelector("#follower_notif").checked;
                let events=document.querySelector("#event_notif").checked;
                let payments=document.querySelector("#payment_notif").checked;

                //Aggiorna la pagina inserendo le preferenze aggiornate
                window.location.href="<%= request.getContextPath() %>/updateSettings?id=<%= activeUser.getId() %>&messages="+messages+"&followers="+followers+"&events="+events+"&payments="+payments;
            }

            window.addEventListener("load", function() {

                document.querySelector("#message_notif").addEventListener("change", updatePreferences);
                document.querySelector("#follower_notif").addEventListener("change", updatePreferences);
                document.querySelector("#event_notif").addEventListener("change", updatePreferences);
                document.querySelector("#payment_notif").addEventListener("change", updatePreferences);
            });
        </script>
    </head>
    <body>
        <%@include file="../include/sidebar.jsp"%>
        <section class="content">
            <!-- Gestione notifiche push e menu campanella dalla pagina impostazioni -->
            <%@include file="../include/notif-bell.jsp"%>
            <%@include file="../include/notif-push.jsp"%>
            <h1>Impostazioni del profilo</h1>
            <div id="settings-container">
                <section id="blocked-users-settings">
                    <!-- Lista utenti bloccati -->
                    <h2><label for="blocked_users_list">Lista utenti bloccati</label></h2>
                    <ul id="blocked_users_list">
                        <% for (var user: blockedUsers) { %>
                            <li>
                                <a href="<%= request.getContextPath() %>/userProfile?id=<%= user.getId() %>&loggedId=<%= activeUser.getId() %>">@<b><%= user.getUsername() %></b></a>
                                <a href="<%= request.getContextPath() %>/unblock?blockedId=<%= user.getId() %>&userId=<%= activeUser.getId() %>"><button class="unblock-button">Sblocca utente</button></a>
                            </li>
                        <% } %>
                    </ul>
                </section>
                <section id="notif-settings">
                    <h2>Preferenze notifiche</h2>
                    <div id="notif-settings-container">
                        <!-- Lista preferenze notifiche -->
                        <p>Selezionare le categorie di notifiche da ricevere</p>
                        <div class="notif-settings-option">
                            <!-- Selezionare la checkbox per ricevere notifiche relative a messaggi ricevuti -->
                            <input type="checkbox" id="message_notif" <%= userPreferences[0] ? "checked" : ""%>>
                            <label for="message_notif">Messaggi</label>
                        </div>
                        <div class="notif-settings-option">
                            <!-- Selezionare la checkbox per ricevere notifiche relative a nuovi follower -->
                            <input type="checkbox" id="follower_notif" <%= userPreferences[1] ? "checked" : ""%>>
                            <label for="follower_notif">Follower</label>
                        </div>
                        <div class="notif-settings-option">
                            <!-- Selezionare la checkbox per ricevere notifiche relative a eventi -->
                            <input type="checkbox" id="event_notif" <%= userPreferences[2] ? "checked" : ""%>>
                            <label for="event_notif">Eventi</label>
                        </div>
                        <div class="notif-settings-option">
                            <!-- Selezionare la checkbox per ricevere notifiche relative a pagamenti ricevuti -->
                            <input type="checkbox" id="payment_notif" <%= userPreferences[3] ? "checked" : ""%>>
                            <label for="payment_notif">Pagamenti</label>
                        </div>
                    </div>
                </section>
            </div>
        </section>
    </body>
</html>