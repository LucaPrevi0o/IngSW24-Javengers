<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% var loggedUser=(User)request.getAttribute("user"); %>
<link rel="stylesheet" href="../../css/sidebar.css" type="text/css" media="screen">
<nav class="sidebar">
    <h1>Qui non ci possiamo mettere solo "Notifiche", perchè è una sidebar che rimane sempre</h1>
    <ul>
        <li class="username"><a class="username-link" href="<%= request.getContextPath() %>/following?id=<%=loggedUser.getId()%>&loggedId=<%=loggedUser.getId()%>">@<b><%= loggedUser.getUsername() %></b></a></li>
        <li class="sidebar-li notif"><a class="sidebar-link" href="<%= request.getContextPath() %>/getByUserId?id=<%= loggedUser.getId() %>"><span>Notifiche</span></a></li>
        <li class="sidebar-li settings"><a class="sidebar-link" href="../jsp/settings.jsp"><span>Impostazioni (il link va sistemato in qualche modo)</span></a></li>
    </ul>
</nav>