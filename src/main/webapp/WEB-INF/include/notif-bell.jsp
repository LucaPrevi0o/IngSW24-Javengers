<%-- JSP della campanella delle notifiche --%>
<%@ page import="java.util.List" %>
<%@ page import="it.unife.ingsw2024.models.notification.Notification" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    var bellUser=(User)request.getAttribute("user");
    var nonRead=((List<Notification>)request.getAttribute("notifications")).stream().filter(n -> !n.isViewed()).toList();
%>

<link rel="stylesheet" href="../../css/notif-bell.css" type="text/css" media="screen">
<script language="javascript">
    /* Numero delle notifiche non lette visualizzato sull'icona della campanella */
    let notifCounter = <%= nonRead.size() %>;

    /* Funzione per aprire/chiudere la lista notifiche della campanella */
    function showNotifiche() {

        const bell = document.getElementById("notifiche-container");
        if (bell.style.display === "block") bell.style.display = "none";
        else bell.style.display = "block";

    }

    function onLoadHandler() {
        document.getElementById("bell-container").addEventListener("click", showNotifiche);
    }

    window.addEventListener("load", onLoadHandler);
</script>
    <div id="bell-wrapper">
    <div id="bell-container">
        <%-- Icona della campanella --%>
        <img src="../../images/notif.png" alt="" width="30" height="30" class="<%= !nonRead.isEmpty() ? "with_notif" : ""%>"/>
        <%-- Numero di notifiche non lette --%>
        <div id="notif-bell-number" style="<%= nonRead.isEmpty() ? "display: none;" : ""%>"><span><%= nonRead.size() %></span></div>
    </div>
    <ul id="notifiche-container">
        <li id="vedi-tutto-container">
            <%-- Pulsante "Vedi tutto" che manda alla pagina notifiche --%>
            <a href="<%= request.getContextPath() %>/getByUserId?id=<%= bellUser.getId() %>"><button id="vedi-tutto">Vedi tutto</button></a>
        </li>
        <% if (nonRead.isEmpty()) { %><p id="no-new-notif">Nessuna nuova notifica</p><% } %>
        <% for (var n: nonRead) { %>
            <li class="notifica da-leggere">
                <%-- Cliccare sulla notifica la segna come letta --%>
                <a href="<%= request.getContextPath() %>/notifclick?id=<%= n.getId() %>&userId=<%= bellUser.getId() %>">
                    <div class="notif-details-wrapper">
                        <div class="notif-details">
                            <p>
                                <img src="../../images/icons/<%= n.getNotificationType() %>.png" width="15" height="15">
                                - @<b style="color: brown"><%= n.getUserSrc().getUsername() %></b>:
                            </p>
                            <hr>
                            <p><%= n.getNotificationMsg() %></p>
                        </div>
                    </div>
                <span class="data-ora"><%= n.getNotificationDate() %> - <%= n.getNotificationTime().toLocalTime() %></span>
                </a>
            </li>
        <% } %>
    </ul>
</div>