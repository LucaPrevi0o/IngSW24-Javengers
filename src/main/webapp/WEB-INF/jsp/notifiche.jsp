<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.List" %>
<%@ page import="it.unife.ingsw2024.models.Notification" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    var notifications=(List<Notification>)request.getAttribute("notifications");
    LocalDate todaysDate=LocalDate.now();
    var today=notifications.stream().filter(n -> n.getNotificationDate().toLocalDate().isEqual(todaysDate)).toList();
    var yesterday=notifications.stream().filter(n -> n.getNotificationDate().toLocalDate().isEqual(todaysDate.minusDays(1))).toList();
    var lastWeek=notifications.stream().filter(n -> n.getNotificationDate().toLocalDate().isAfter(todaysDate.minusDays(7)) && n.getNotificationDate().toLocalDate().isBefore(todaysDate.minusDays(1))).toList();
    var lastMonth=notifications.stream().filter(n -> n.getNotificationDate().toLocalDate().isAfter(todaysDate.minusDays(30)) && n.getNotificationDate().toLocalDate().isBefore(todaysDate.minusDays(7))).toList();
    var older=notifications.stream().filter(n -> n.getNotificationDate().toLocalDate().isBefore(todaysDate.minusDays(30))).toList();
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
            <%@include file="../include/notif-bell.jsp"%>
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
                                    <p>@<b><%= n.getUserSrc().getUsername() %></b>:</p>
                                    <hr style="margin-bottom: 5px; margin-top: 2px">
                                    <div class="notif-details">
                                        <p style="color: cornflowerblue"><b><%= n.getNotificationLiteralType() %></b></p>
                                        <p><%= n.getNotificationMsg() %></p>
                                    </div>
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
                            <p>@<b><%= n.getUserSrc().getUsername() %></b>:</p>
                            <hr style="margin-bottom: 5px; margin-top: 2px">
                            <div class="notif-details">
                                <p style="color: cornflowerblue"><b><%= n.getNotificationLiteralType() %></b></p>
                                <p><%= n.getNotificationMsg() %></p>
                            </div>
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
                            <p>@<b><%= n.getUserSrc().getUsername() %></b>:</p>
                            <hr style="margin-bottom: 5px; margin-top: 2px">
                            <div class="notif-details">
                                <p style="color: cornflowerblue"><b><%= n.getNotificationLiteralType() %></b></p>
                                <p><%= n.getNotificationMsg() %></p>
                            </div>
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
                            <p>@<b><%= n.getUserSrc().getUsername() %></b>:</p>
                            <hr style="margin-bottom: 5px; margin-top: 2px">
                            <div class="notif-details">
                                <p style="color: cornflowerblue"><b><%= n.getNotificationLiteralType() %></b></p>
                                <p><%= n.getNotificationMsg() %></p>
                            </div>
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
                            <p>@<b><%= n.getUserSrc().getUsername() %></b>:</p>
                            <hr style="margin-bottom: 5px; margin-top: 2px">
                            <div class="notif-details">
                                <p style="color: cornflowerblue"><b><%= n.getNotificationLiteralType() %></b></p>
                                <p><%= n.getNotificationMsg() %></p>
                            </div>
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