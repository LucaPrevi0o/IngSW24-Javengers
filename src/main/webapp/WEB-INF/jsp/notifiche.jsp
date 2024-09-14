<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.List" %>
<%@ page import="it.unife.ingsw2024.models.notification.Notification" %>
<%@ page import="it.unife.ingsw2024.models.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    var titoloSidebar = "Notifiche";
    var user=(User)request.getAttribute("user");
    var notifications=(List<Notification>)request.getAttribute("notifications");
    var todaysDate=LocalDate.now();
    var today=notifications.stream().filter(n -> n.getNotificationDate().toLocalDate().isEqual(todaysDate)).toList();
    var yesterday=notifications.stream().filter(n -> n.getNotificationDate().toLocalDate().isEqual(todaysDate.minusDays(1))).toList();
    var lastWeek=notifications.stream().filter(n -> n.getNotificationDate().toLocalDate().isAfter(todaysDate.minusDays(7)) && n.getNotificationDate().toLocalDate().isBefore(todaysDate.minusDays(1))).toList();
    var lastMonth=notifications.stream().filter(n -> n.getNotificationDate().toLocalDate().isAfter(todaysDate.minusDays(30)) && n.getNotificationDate().toLocalDate().isBefore(todaysDate.minusDays(7))).toList();
    var older=notifications.stream().filter(n -> n.getNotificationDate().toLocalDate().isBefore(todaysDate.minusDays(30))).toList();
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Notifiche - @<%= user.getUsername() %></title>
        <link rel="stylesheet" href="../../css/notifiche.css" type="text/css" media="screen">
        <script type="text/javascript">

            /* Funzione per filtrare le notifiche in base al tipo */
            function changeViewByType(selectedNotifType){
                /* Resetto la view rimettendo tutti i display a flex */
                Array.from(document.querySelectorAll('.notif-container')).forEach(
                    (notif) => {
                        notif.style.display = "flex";
                    }
                );

                if(selectedNotifType != "Tutto") {
                    /* Per ogni elemento con classe .notif-container setto display=none se l'attributo tipoNotifica è diverso da quello selezionato */
                    Array.from(document.querySelectorAll('.notif-container')).forEach((notif) => {
                        var tipoNotifica = notif.getAttribute('tipoNotifica');

                        if (tipoNotifica == selectedNotifType) {
                            notif.style.display = "flex";
                        } else {
                            notif.style.display = "none";
                        }
                    });
                }

            }

            /* Funzione per filtrare le notifiche in base al nome utente del mittente */
            function changeViewByUsername(username){
                /* Converto tutto a lowercase per fare un confronto case-insensitive */
                var searchUsername = username.toLowerCase();

                /* Per ogni elemento con classe .notif-container setto display=none se l'attributo usernameSrc è diverso da quello selezionato */
                Array.from(document.querySelectorAll('.notif-container')).forEach((notif) => {
                    var notifUsername = notif.getAttribute('usernameSrc').toLowerCase();

                    if (notifUsername.includes(searchUsername)) {
                        notif.style.display = "flex";
                    } else {
                        notif.style.display = "none";
                    }
                });
            }

            /* Funzione per filtrare le notifiche in base al messaggio */
            function changeViewByContent(selectedContent){
                /* Converto tutto a lowercase per fare un confronto case-insensitive */
                var content = selectedContent.toLowerCase();

                /* Per ogni elemento con classe .notif-container setto display=none se l'attributo contenutoNotifica è diverso da quello selezionato */
                Array.from(document.querySelectorAll('.notif-container')).forEach((notif) => {
                    var notifContent = notif.getAttribute('contenutoNotifica').toLowerCase();

                    if (notifContent.includes(content)) {
                        notif.style.display = "flex";
                    } else {
                        notif.style.display = "none";
                    }
                });
            }

            function onLoadHandler() {
                document.getElementById("search_notiftype").addEventListener("change", (event) => changeViewByType(event.currentTarget.value));
                document.getElementById("search_notifuser").addEventListener("input", (event) => changeViewByUsername(event.currentTarget.value));
                document.getElementById("search_notifcontent").addEventListener("input", (event) => changeViewByContent(event.currentTarget.value));
            }

            window.addEventListener("load", onLoadHandler);
        </script>
    </head>
    <body>
        <%@include file="../include/sidebar.jsp"%>
        <section class="content">
            <%@include file="../include/notif-bell.jsp"%>
            <%@include file="../include/notif-push.jsp"%>
            <%-- Pulsanti per segnare tutto come letto/cancellare notifiche lette --%>
            <a href="<%= request.getContextPath() %>/setAllAsRead?id=<%= user.getId() %>"><button id="read-button">Segna tutto come letto</button></a>
            <a href="<%= request.getContextPath() %>/deleteAllRead?id=<%= user.getId() %>"><button id="delete-button">Elimina notifiche lette</button></a><br/>
            <%-- Filtro delle notifiche in base al tipo --%>
            <div class="filter-container">
                <label for="search_notiftype">Filtra in base al tipo di notifica</label>
                <select id="search_notiftype" style="width: 200px; height: 30px;">
                    <option value="Tutto">Tutto</option>
                    <option value="Messaggi">Messaggi</option>
                    <option value="Follower">Follower</option>
                    <option value="Eventi">Eventi</option>
                    <option value="Pagamenti">Pagamenti</option>
                </select>
            </div>
            <%-- Filtro delle notifiche in base al nome utente --%>
            <div class="filter-container">
                <label for="search_notifuser">Cerca in base al nome utente</label>
                <input type="search" id="search_notifuser" placeholder="Username..." style="width: 200px; height: 30px;">
            </div>
            <%-- Filtro delle notifiche in base al contenuto --%>
            <div class="filter-container">
                <label for="search_notifcontent">Cerca in base al contenuto</label>
                <input type="search" id="search_notifcontent" placeholder="Cerca..." style="width: 200px; height: 30px;">
            </div>
            <%-- Lista delle notifiche divise per periodo temporale --%>
            <ul id="lista-notifiche">
                <% if (!today.isEmpty()) { %><li class="giorno"><p>Oggi</p></li><% } %>
                <%-- Lista delle notifiche ricevute oggi --%>
                <% for (var n: today) { %>
                    <%@include file="../include/notif-single.jsp"%>
                <% } %>
                <% if (!yesterday.isEmpty()) { %><li class="giorno"><p>Ieri</p></li><% } %>
                <%-- Lista delle notifiche ricevute ieri --%>
                <% for (var n: yesterday) { %>
                    <%@include file="../include/notif-single.jsp"%>
                <% } %>
                <% if(!lastWeek.isEmpty()) {%><li class="giorno"><p>Ultima settimana</p></li><%}%>
                <%-- Lista delle notifiche ricevute durante l'ultima settimana --%>
                <% for (var n: lastWeek) { %>
                    <%@include file="../include/notif-single.jsp"%>
                <% } %>
                <% if(!lastMonth.isEmpty()) {%><li class="giorno"><p>Ultimo mese</p></li><%}%>
                <%-- Lista delle notifiche ricevute durante l'ultimo mese --%>
                <% for (var n: lastMonth) { %>
                    <%@include file="../include/notif-single.jsp"%>
                <% } %>
                <% if(!older.isEmpty()) {%><li class="giorno"><p>Meno recenti</p></li><%}%>
                <%-- Lista delle notifiche ricevute più di un mese fa --%>
                <% for (var n: older) { %>
                    <%@include file="../include/notif-single.jsp"%>
                <% } %>
            </ul>
        </section>
    </body>
</html>