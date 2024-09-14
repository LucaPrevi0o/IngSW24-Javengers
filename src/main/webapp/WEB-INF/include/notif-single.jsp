<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Notifica da visualizzare all'interno dei cicli for in notifiche.jsp --%>
<li class="notif-container" tipoNotifica="<%=n.getNotificationType()%>" usernameSrc="<%= n.getUserSrc().getUsername() %>" contenutoNotifica="<%= n.getNotificationMsg() %>">
    <div class="notifica">
        <div class="notif-wrapper <%=!n.isViewed() ? "da-leggere" : ""%>">
            <%-- Cliccare sull'immagine profilo o sull'username porta al profilo corrispondente --%>
            <div><a href="<%= request.getContextPath() %>/following?id=<%=n.getUserSrc().getId()%>&loggedId=<%= loggedUser.getId() %>" style="display: inline-block"><img src="../../images/propic.jpg" alt="immagine profilo" width="50" height="50"/></a></div>
            <div class="notif-content">
                <a href="<%= request.getContextPath() %>/following?id=<%=n.getUserSrc().getId()%>&loggedId=<%= loggedUser.getId() %>"><p class="username">@<b class="username-bold"><%= n.getUserSrc().getUsername() %></b>:</p></a>
                <hr style="margin-bottom: 5px; margin-top: 2px">
                <%-- Cliccare sul contenuto segna la notifica come letta --%>
                <a href="<%= request.getContextPath() %>/notifclick?id=<%= n.getId() %>&userId=<%= loggedUser.getId() %>">
                    <div class="notif-details">
                        <p style="color: cornflowerblue"><b><%= n.getNotificationType() %></b></p>
                        <p><%= n.getNotificationMsg() %></p>
                    </div>
                </a>
                <span class="ora"><%= n.getNotificationDate() %> - <%= n.getNotificationTime().toLocalTime() %></span>
            </div>
        </div>
    </div>
    <% if (!n.isViewed()) { %><img class="da-leggere-icon" src="../../images/1268.png" alt="da-leggere" height="25" width="25"/><% } %>
</li>