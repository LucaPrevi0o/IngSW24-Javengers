<%@ page import="java.util.List" %>
<%@ page import="it.unife.ingsw2024.models.Notification" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    var bellUser=(User)request.getAttribute("user");
    var nonRead=((List<Notification>)request.getAttribute("notifications")).stream().filter(n -> !n.isViewed()).toList();
%>

<link rel="stylesheet" href="../../css/notif-bell.css" type="text/css" media="screen">
<script language="javascript">
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
    <div style="position: relative; display: flex; flex-direction: column; align-items: flex-end; justify-content: center">
    <div id="bell-container">
        <img src="../../images/notif.png" alt="" width="30" height="30" />
    </div>
    <ul id="notifiche-container">
        <li><a href="<%= request.getContextPath() %>/notifiche?id=<%= bellUser.getId() %>"><button id="vedi-tutto">Vedi tutto</button></a></li>
        <% for (var n: nonRead) { %>
            <li class="notifica da-leggere">
                <a href="">
                    <div style="display: flex; flex-direction: row; align-items: center;">
                        <div class="notif-details">
                            <p>
                                <img src="../../images/icons/<%= n.getNotificationType() %>.png" width="15" height="15">
                                - @<b style="color: brown"><%= n.getUserSrc().getUsername() %></b>:
                            </p>
                            <hr style="margin-bottom: 5px; margin-top: 2px">
                            <p><%= n.getNotificationMsg() %></p>
                        </div>
                        <!--img class="da-leggere-icon" src="../../images/1268.png" alt="da-leggere" height="20" width="20" style="margin-left: 10px;"/-->
                    </div>
                <span class="data-ora"><%= n.getNotificationDate() %> - <%= n.getNotificationTime().toLocalTime() %></span>
                </a>
            </li>
        <% } %>
    </ul>
</div>