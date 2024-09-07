<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.List" %>
<%@ page import="it.unife.ingsw2024.models.Notification" %>
<%@ page import="it.unife.ingsw2024.models.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
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
    </head>
    <body>
        <%@include file="../include/sidebar.jsp"%>
        <section class="content">
            <%@include file="../include/notif-bell.jsp"%>
            <%@include file="../include/notif-push.jsp"%>
            <a href="<%= request.getContextPath() %>/setAllAsRead?id=<%= user.getId() %>"><button id="read-button">Segna tutto come letto</button></a>
            <a href="<%= request.getContextPath() %>/deleteAllRead?id=<%= user.getId() %>"><button id="delete-button">Elimina notifiche lette</button></a>
            <ul id="lista-notifiche">
                <% if (!today.isEmpty()) { %><li class="giorno"><p>Oggi</p></li><% } %>
                <% for (var n: today) { %>
                <li class="notif-container">
                    <div class="notifica">
                        <% if (!n.isViewed()) { %><div class="da-leggere notif-wrapper">
                        <% } else { %><div class="notif-wrapper"><% } %>
                        <div><a href="<%= request.getContextPath() %>/following?id=<%=n.getUserSrc().getId()%>&loggedId=<%= loggedUser.getId() %>" style="display: inline-block"><img src="../../images/propic.jpg" alt="immagine profilo" width="50" height="50"/></a></div>
                        <div class="notif-content">
                            <a href="<%= request.getContextPath() %>/following?id=<%=n.getUserSrc().getId()%>&loggedId=<%= loggedUser.getId() %>"><p class="username">@<b style="color: brown"><%= n.getUserSrc().getUsername() %></b>:</p></a>
                            <hr style="margin-bottom: 5px; margin-top: 2px">
                            <a href="<%= request.getContextPath() %>/notifclick?id=<%= n.getId() %>&userId=<%= loggedUser.getId() %>">
                                <div class="notif-details">
                                    <p style="color: cornflowerblue"><b><%= n.getNotificationLiteralType() %></b></p>
                                    <p><%= n.getNotificationMsg() %></p>
                                </div>
                            </a>
                            <span class="ora"><%= n.getNotificationDate() %> - <%= n.getNotificationTime().toLocalTime() %></span>
                        </div>
                    </div>
                    </div>
                            <% if (!n.isViewed()) { %><img class="da-leggere-icon" src="../../images/1268.png" alt="da-leggere" height="25" width="25"/><% } %>
                </li>
                <% } %>
                <% if (!yesterday.isEmpty()) { %><li class="giorno"><p>Ieri</p></li><% } %>
                <% for (var n: yesterday) { %>
                <li class="notif-container">
                    <div class="notifica">
                        <% if (!n.isViewed()) { %><div class="da-leggere notif-wrapper">
                            <% } else { %><div class="notif-wrapper"><% } %>
                            <div><a href="<%= request.getContextPath() %>/following?id=<%=n.getUserSrc().getId()%>&loggedId=<%= loggedUser.getId() %>" style="display: inline-block"><img src="../../images/propic.jpg" alt="immagine profilo" width="50" height="50"/></a></div>
                        <div class="notif-content">
                            <a href="<%= request.getContextPath() %>/following?id=<%=n.getUserSrc().getId()%>&loggedId=<%= loggedUser.getId() %>"><p class="username">@<b style="color: brown"><%= n.getUserSrc().getUsername() %></b>:</p></a>
                            <hr style="margin-bottom: 5px; margin-top: 2px">
                            <a href="<%= request.getContextPath() %>/notifclick?id=<%= n.getId() %>&userId=<%= loggedUser.getId() %>">
                                <div class="notif-details">
                                    <p style="color: cornflowerblue"><b><%= n.getNotificationLiteralType() %></b></p>
                                    <p><%= n.getNotificationMsg() %></p>
                                </div>
                            </a>
                            <span class="ora"><%= n.getNotificationDate() %> - <%= n.getNotificationTime().toLocalTime() %></span>
                        </div>
                    </div>
                    </div>
                    <% if (!n.isViewed()) { %><img class="da-leggere-icon" src="../../images/1268.png" alt="da-leggere" height="25" width="25"/><% } %>
                </li>
                <% } %>
                <% if(!lastWeek.isEmpty()) {%><li class="giorno"><p>Ultima settimana</p></li><%}%>
                <% for (var n: lastWeek) { %>
                <li class="notif-container">
                    <div class="notifica">
                            <% if (!n.isViewed()) { %><div class="da-leggere notif-wrapper">
                        <% } else { %><div class="notif-wrapper"><% } %>
                        <div><a href="<%= request.getContextPath() %>/following?id=<%=n.getUserSrc().getId()%>&loggedId=<%= loggedUser.getId() %>" style="display: inline-block"><img src="../../images/propic.jpg" alt="immagine profilo" width="50" height="50"/></a></div>
                        <div class="notif-content">
                            <a href="<%= request.getContextPath() %>/following?id=<%=n.getUserSrc().getId()%>&loggedId=<%= loggedUser.getId() %>"><p class="username">@<b style="color: brown"><%= n.getUserSrc().getUsername() %></b>:</p></a>
                            <hr style="margin-bottom: 5px; margin-top: 2px">
                            <a href="<%= request.getContextPath() %>/notifclick?id=<%= n.getId() %>&userId=<%= loggedUser.getId() %>">
                                <div class="notif-details">
                                    <p style="color: cornflowerblue"><b><%= n.getNotificationLiteralType() %></b></p>
                                    <p><%= n.getNotificationMsg() %></p>
                                </div>
                            </a>
                            <span class="ora"><%= n.getNotificationDate() %> - <%= n.getNotificationTime().toLocalTime() %></span>
                        </div>
                    </div>
                    </div>
                            <% if (!n.isViewed()) { %><img class="da-leggere-icon" src="../../images/1268.png" alt="da-leggere" height="25" width="25"/><% } %>
                </li>
                <% } %>
                <% if(!lastMonth.isEmpty()) {%><li class="giorno"><p>Ultimo mese</p></li><%}%>
                <% for (var n: lastMonth) { %>
                <li class="notif-container">
                    <div class="notifica">
                            <% if (!n.isViewed()) { %><div class="da-leggere notif-wrapper">
                        <% } else { %><div class="notif-wrapper"><% } %>
                        <div><a href="<%= request.getContextPath() %>/following?id=<%=n.getUserSrc().getId()%>&loggedId=<%= loggedUser.getId() %>" style="display: inline-block"><img src="../../images/propic.jpg" alt="immagine profilo" width="50" height="50"/></a></div>
                        <div class="notif-content">
                            <a href="<%= request.getContextPath() %>/following?id=<%=n.getUserSrc().getId()%>&loggedId=<%= loggedUser.getId() %>"><p class="username">@<b style="color: brown"><%= n.getUserSrc().getUsername() %></b>:</p></a>
                            <hr style="margin-bottom: 5px; margin-top: 2px">
                            <a href="<%= request.getContextPath() %>/notifclick?id=<%= n.getId() %>&userId=<%= loggedUser.getId() %>">
                                <div class="notif-details">
                                    <p style="color: cornflowerblue"><b><%= n.getNotificationLiteralType() %></b></p>
                                    <p><%= n.getNotificationMsg() %></p>
                                </div>
                            </a>
                            <span class="ora"><%= n.getNotificationDate() %> - <%= n.getNotificationTime().toLocalTime() %></span>
                        </div>
                    </div>
                    </div>
                            <% if (!n.isViewed()) { %><img class="da-leggere-icon" src="../../images/1268.png" alt="da-leggere" height="25" width="25"/><% } %>
                </li>
                <% } %>
                <% if(!older.isEmpty()) {%><li class="giorno"><p>Meno recenti</p></li><%}%>
                <% for (var n: older) { %>
                <li class="notif-container">
                    <div class="notifica">
                            <% if (!n.isViewed()) { %><div class="da-leggere notif-wrapper">
                        <% } else { %><div class="notif-wrapper"><% } %>
                        <div><a href="<%= request.getContextPath() %>/following?id=<%=n.getUserSrc().getId()%>&loggedId=<%= loggedUser.getId() %>" style="display: inline-block"><img src="../../images/propic.jpg" alt="immagine profilo" width="50" height="50"/></a></div>
                        <div class="notif-content">
                            <a href="<%= request.getContextPath() %>/following?id=<%=n.getUserSrc().getId()%>&loggedId=<%= loggedUser.getId() %>"><p class="username">@<b style="color: brown"><%= n.getUserSrc().getUsername() %></b>:</p></a>
                            <hr style="margin-bottom: 5px; margin-top: 2px">
                            <a href="<%= request.getContextPath() %>/notifclick?id=<%= n.getId() %>&userId=<%= loggedUser.getId() %>">
                                <div class="notif-details">
                                    <p style="color: cornflowerblue"><b><%= n.getNotificationLiteralType() %></b></p>
                                    <p><%= n.getNotificationMsg() %></p>
                                </div>
                            </a>
                            <span class="ora"><%= n.getNotificationDate() %> - <%= n.getNotificationTime().toLocalTime() %></span>
                        </div>
                    </div>
                    </div>
                            <% if (!n.isViewed()) { %><img class="da-leggere-icon" src="../../images/1268.png" alt="da-leggere" height="25" width="25"/><% } %>
                </li>
                <% } %>
            </ul>
        </section>
    </body>
</html>