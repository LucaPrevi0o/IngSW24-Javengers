<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.List" %>
<%@ page import="it.unife.ingsw2024.models.Notification" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Objects" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="org.hibernate.type.descriptor.DateTimeUtils" %>
<%@ page import="org.springframework.cglib.core.Local" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% var notifications=(List<Notification>)request.getAttribute("notifications");
    List<Notification> today=new ArrayList<>(), yesterday=new ArrayList<>(), lastWeek=new ArrayList<>(), lastMonth=new ArrayList<>(), older=new ArrayList<>();
    LocalDate todaysDate = LocalDate.now();
    for (var notification: notifications) {
        today=notifications.stream().filter(n -> n.getNotificationDate().toLocalDate().isEqual(todaysDate)).toList();
        System.out.println("TODAYCHECK: " + notification.getNotificationDate().toLocalDate() + " " + LocalDate.now());
        yesterday=notifications.stream().filter(n -> n.getNotificationDate().toLocalDate().isEqual(todaysDate.minusDays(1))).toList();
        lastWeek=notifications.stream().filter(n -> n.getNotificationDate().toLocalDate().isAfter(todaysDate.minusDays(7)) && n.getNotificationDate().toLocalDate().isBefore(todaysDate.minusDays(1))).toList();
        lastMonth=notifications.stream().filter(n -> n.getNotificationDate().toLocalDate().isAfter(todaysDate.minusDays(30)) && n.getNotificationDate().toLocalDate().isBefore(todaysDate.minusDays(7))).toList();
        older=notifications.stream().filter(n -> n.getNotificationDate().toLocalDate().isBefore(todaysDate.minusDays(30))).toList();
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Notifiche</title>
        <link rel="stylesheet" href="../../css/notifiche.css" type="text/css" media="screen">
        <script language="javascript">
            function removeRead() {

                Array.from(document.querySelectorAll('.da-leggere')).forEach((item) => { item.classList.remove('da-leggere'); });
                document.querySelectorAll('.da-leggere-icon').forEach(icon => icon.remove());
            }

            function onLoadHandler() { document.getElementById("read-button").addEventListener("click", removeRead); }

            window.addEventListener("load", onLoadHandler);
        </script>
    </head>
    <body>
        <nav class="sidebar">
            <h1>Notifiche</h1>
            <ul>
                <li class="notif"><a href=""><span>Notifiche</span></a></li>
                <li class="settings"><a href=""><span>Impostazioni</span></a></li>
            </ul>
        </nav>
        <section class="content">
            <%@include file="../include/notif-bell.inc"%>
            <button id="read-button">Segna tutto come letto</button>
            <ul class="lista-notifiche">
                <% if(!today.isEmpty()) {%><li class="giorno"><p>Oggi</p></li><%}%>
                <% for (var n: today) { %>
                    <li class="notif-container">
                        <div class="notifica">
                            <% if (!n.isViewed()) { %><a class="da-leggere" href="/notifclick?id=<%= n.getId() %>">
                            <% } else { %><a href=""><% } %>
                                <img src="../../images/propic.jpg" alt="immagine profilo" width="50" height="50"/>
                                <div class="notif-content">
                                    <div class="notif-details"><p><%= n.getNotificationMsg() %></p></div>
                                    <span class="ora"><%= n.getNotificationDate() %> - <%= n.getNotificationTime().toLocalTime() %></span>
                                </div>
                            </a>
                        </div>
                        <% if (!n.isViewed()) { %><img class="da-leggere-icon" src="../../images/1268.png" alt="da-leggere" height="25" width="25"/><% } %>
                    </li>
                <% } %>
                <% if(!yesterday.isEmpty()) {%><li class="giorno"><p>Ieri</p></li><%}%>
                <% for (var n: yesterday) { %>
                <li class="notif-container">
                    <div class="notifica">
                        <% if (!n.isViewed()) { %><a class="da-leggere" href="/notifclick?id=<%= n.getId() %>">
                            <% } else { %><a href=""><% } %>
                        <img src="../../images/propic.jpg" alt="immagine profilo" width="50" height="50"/>
                        <div class="notif-content">
                            <div class="notif-details"><p><%= n.getNotificationMsg() %></p></div>
                            <span class="ora"><%= n.getNotificationDate() %> - <%= n.getNotificationTime().toLocalTime() %></span>
                        </div>
                    </a>
                    </div>
                    <% if (!n.isViewed()) { %><img class="da-leggere-icon" src="../../images/1268.png" alt="da-leggere" height="25" width="25"/><% } %>
                </li>
                <% } %>
                <% if(!lastWeek.isEmpty()) {%><li class="giorno"><p>Ultima settimana</p></li><%}%>
                <% for (var n: lastWeek) { %>
                <li class="notif-container">
                    <div class="notifica">
                        <% if (!n.isViewed()) { %><a class="da-leggere" href="/notifclick?id=<%= n.getId() %>">
                            <% } else { %><a href=""><% } %>
                        <img src="../../images/propic.jpg" alt="immagine profilo" width="50" height="50"/>
                        <div class="notif-content">
                            <div class="notif-details"><p><%= n.getNotificationMsg() %></p></div>
                            <span class="ora"><%= n.getNotificationDate() %> - <%= n.getNotificationTime().toLocalTime() %></span>
                        </div>
                    </a>
                    </div>
                    <% if (!n.isViewed()) { %><img class="da-leggere-icon" src="../../images/1268.png" alt="da-leggere" height="25" width="25"/><% } %>
                </li>
                <% } %>
                <% if(!lastMonth.isEmpty()) {%><li class="giorno"><p>Ultimo mese</p></li><%}%>
                <% for (var n: lastMonth) { %>
                <li class="notif-container">
                    <div class="notifica">
                        <% if (!n.isViewed()) { %><a class="da-leggere" href="/notifclick?id=<%= n.getId() %>">
                            <% } else { %><a href=""><% } %>
                        <img src="../../images/propic.jpg" alt="immagine profilo" width="50" height="50"/>
                        <div class="notif-content">
                            <div class="notif-details"><p><%= n.getNotificationMsg() %></p></div>
                            <span class="ora"><%= n.getNotificationDate() %> - <%= n.getNotificationTime().toLocalTime() %></span>
                        </div>
                    </a>
                    </div>
                    <% if (!n.isViewed()) { %><img class="da-leggere-icon" src="../../images/1268.png" alt="da-leggere" height="25" width="25"/><% } %>
                </li>
                <% } %>
                <% if(!older.isEmpty()) {%><li class="giorno"><p>Meno recenti</p></li><%}%>
                <% for (var n: older) { %>
                <li class="notif-container">
                    <div class="notifica">
                        <% if (!n.isViewed()) { %><a class="da-leggere" href="/notifclick?id=<%= n.getId() %>">
                            <% } else { %><a href=""><% } %>
                        <img src="../../images/propic.jpg" alt="immagine profilo" width="50" height="50"/>
                        <div class="notif-content">
                            <div class="notif-details"><p><%= n.getNotificationMsg() %></p></div>
                            <span class="ora"><%= n.getNotificationDate() %> - <%= n.getNotificationTime().toLocalTime() %></span>
                        </div>
                    </a>
                    </div>
                    <% if (!n.isViewed()) { %><img class="da-leggere-icon" src="../../images/1268.png" alt="da-leggere" height="25" width="25"/><% } %>
                </li>
                <% } %>
            </ul>
        </section>
    </body>
</html>