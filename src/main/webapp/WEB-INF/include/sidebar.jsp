<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% var loggedUser=(User)request.getAttribute("user"); %>
<link rel="stylesheet" href="../../css/sidebar.css" type="text/css" media="screen">
<nav class="sidebar">
    <h1>Notifiche</h1>
    <ul>
        <li>@<b style="color: brown"><%= loggedUser.getUsername() %></b></li>
        <li class="notif"><a href="/getByUserId?id=<%= loggedUser.getId() %>"><span>Notifiche</span></a></li>
        <li class="settings"><a href=""><span>Impostazioni</span></a></li>
    </ul>
</nav>