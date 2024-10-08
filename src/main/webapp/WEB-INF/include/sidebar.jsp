<%@ page import="it.unife.ingsw2024.models.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% var loggedUser=(User)request.getAttribute("user"); %>
<link rel="stylesheet" href="../../css/sidebar.css" type="text/css" media="screen">
<nav class="sidebar">
    <%-- Il titolo della sidebar cambia in base alla pagina visualizzata --%>
    <h1><%=titoloSidebar%></h1>
    <ul>
        <li class="username"><a class="username-link" href="<%= request.getContextPath() %>/userProfile?id=<%=loggedUser.getId()%>&loggedId=<%=loggedUser.getId()%>">@<b><%= loggedUser.getUsername() %></b></a></li>
        <li class="sidebar-li notif"><a class="sidebar-link" href="<%= request.getContextPath() %>/getByUserId?id=<%= loggedUser.getId() %>"><span>Notifiche</span></a></li>
        <li class="sidebar-li settings"><a class="sidebar-link" href="<%= request.getContextPath() %>/settings?id=<%= loggedUser.getId() %>"><span>Impostazioni</span></a></li>
    </ul>
</nav>