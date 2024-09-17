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
            //Funzione di filtraggio notifiche, in base al tipo di filtraggio e al valore del campo
            function filter(field, filterType) {

                //Resetto la view rimettendo tutti i display a flex
                Array.from(document.querySelectorAll('.notif-container')).forEach((notif) => { notif.style.display = "flex"; });

                //Converto tutto a lowercase per fare un confronto case-insensitive
                let searchFilter=field.toLowerCase();

                //Il filtraggio non viene applicato solo se il filtro è in base al tipo e viene applicato il valore "Tutto"
                if (filterType!=='tipoNotifica' || field!=="Tutto") {

                    //Per ogni elemento con classe .notif-container setto display=none se l'attributo usernameSrc è diverso da quello selezionato
                    Array.from(document.querySelectorAll('.notif-container')).forEach((notif) => {

                        let selectedField=notif.getAttribute(filterType).toLowerCase(); //confronto attributi lower-case
                        if (selectedField.includes(searchFilter)) notif.style.display="flex";
                        else notif.style.display="none";
                    });
                }
            }

            window.addEventListener("load", function() {

                document.getElementById("search_notiftype").addEventListener("change", (event) => filter(event.currentTarget.value, "tipoNotifica"));
                document.getElementById("search_notifuser").addEventListener("input", (event) => filter(event.currentTarget.value, "usernameSrc"));
                document.getElementById("search_notifcontent").addEventListener("input", (event) => filter(event.currentTarget.value, "contenutoNotifica"));
            });
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
                <% for (var n: today) { %><%@include file="../include/notif-single.jsp"%><% } //display lista notifiche %>
                <% if (!yesterday.isEmpty()) { %><li class="giorno"><p>Ieri</p></li><% } %>
                <%-- Lista delle notifiche ricevute ieri --%>
                <% for (var n: yesterday) { %><%@include file="../include/notif-single.jsp"%><% } //display lista notifiche %>
                <% if (!lastWeek.isEmpty()) { %><li class="giorno"><p>Ultima settimana</p></li><% } %>
                <%-- Lista delle notifiche ricevute durante l'ultima settimana --%>
                <% for (var n: lastWeek) { %><%@include file="../include/notif-single.jsp"%><% } //display lista notifiche %>
                <% if (!lastMonth.isEmpty()) { %><li class="giorno"><p>Ultimo mese</p></li><% } %>
                <%-- Lista delle notifiche ricevute durante l'ultimo mese --%>
                <% for (var n: lastMonth) { %><%@include file="../include/notif-single.jsp"%><% } //display lista notifiche %>
                <% if (!older.isEmpty()) { %><li class="giorno"><p>Meno recenti</p></li><% } %>
                <%-- Lista delle notifiche ricevute più di un mese fa --%>
                <% for (var n: older) { %><%@include file="../include/notif-single.jsp"%><% } //display lista notifiche %>
            </ul>
        </section>
    </body>
</html>