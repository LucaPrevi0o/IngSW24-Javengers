<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.List" %>
<%@ page import="it.unife.ingsw2024.models.Notification" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% var notifications=(List<Notification>)request.getAttribute("notifications"); %>
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
                <% List<Notification> today=new ArrayList<>(), yesterday=new ArrayList<>(), lastWeek=new ArrayList<>(), lastMonth=new ArrayList<>();
                for (var notification: notifications) {

                    today=notifications.stream().filter(todayNotification -> notification.getNotificationDate().toLocalDate().getDayOfYear()==LocalDate.now().getDayOfYear()).toList();
                    yesterday=notifications.stream().filter(yesterdayNotification -> notification.getNotificationDate().toLocalDate().getDayOfYear()==LocalDate.now().getDayOfYear()-1).toList();
                    lastWeek=notifications.stream().filter(lastWeekNotification -> notification.getNotificationDate().toLocalDate().getDayOfYear()<LocalDate.now().getDayOfYear()-1 && notification.getNotificationDate().toLocalDate().getDayOfYear()>=LocalDate.now().getDayOfYear()-7).toList();
                    lastMonth=notifications.stream().filter(lastMonthNotification -> notification.getNotificationDate().toLocalDate().getDayOfYear()<LocalDate.now().getDayOfYear()-7 && notification.getNotificationDate().toLocalDate().getDayOfYear()>=LocalDate.now().getDayOfYear()-30).toList();
                } %>
                <li class="giorno"><p>Oggi</p></li>
                <li class="notif-container">
                    <% for (var n: today) { %>
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
                    <% } %>
                </li>
                <li class="giorno"><p>Ieri</p></li>
                <li class="notif-container">
                    <% for (var n: yesterday) { %>
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
                    <% } %>
                </li>
                <li class="giorno"><p>Ultima settimana</p></li>
                <li class="notif-container">
                    <% for (var n: lastWeek) { %>
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
                    <% } %>
                </li>
                <li class="giorno"><p>Ultimo mese</p></li>
                <li class="notif-container">
                    <% for (var n: lastMonth) { %>
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
                    <% } %>
                </li>
            </ul>
        </section>
    </body>
</html>