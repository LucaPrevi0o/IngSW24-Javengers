<%@ page import="it.unife.ingsw2024.models.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    var selectedUser =(User) request.getAttribute("selectedUser");
    var followerList =(List<User>) request.getAttribute("followerList");
    var followedList =(List<User>) request.getAttribute("followedList");
 %>
<!DOCTYPE html>
<html>
    <head>
        <title>Following</title>
        <link rel="stylesheet" href="../../css/following.css" type="text/css" media="screen">
    </head>
    <body>
        <%@include file="../include/sidebar.jsp"%>
        <section class="content">
            <%@include file="../include/notif-bell.jsp"%>
            <div class="container">
                <section class="utente-container">
                    <img id="propic" src="../../images/propic.jpg" alt="Profile picture" width="60" height="60"/>
                    <span>@<%= selectedUser.getUsername() %></span>
                </section>
            <section class="following-container">
                <div class="followers">
                    <h2>Followers</h2>
                    <span><%= followerList.size() %></span>
                    <% for (var f: followerList) { %>
                        <a href="/following?id=<%= f.getId() %>"><p>@<b><%= f.getUsername() %></b>:</p></a>
                    <% } %>
                </div>
                <div class="followed">
                    <h2>Following</h2>
                    <span><%= followedList.size() %></span>
                    <% for (var f: followedList) { %>
                    <a href="/following?id=<%= f.getId() %>"><p>@<b><%= f.getUsername() %></b>:</p></a>
                    <% } %>
                </div>
            </section>
            <button class="segui-button">Segui</button>
            </div>
        </section>
    </body>
</html>