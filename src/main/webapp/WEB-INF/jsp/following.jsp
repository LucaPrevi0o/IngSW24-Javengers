<%@ page import="it.unife.ingsw2024.models.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    var user=(User)request.getAttribute("user");
    var selectedUser=(User)request.getAttribute("selectedUser");
    var followerList=(List<User>)request.getAttribute("followerList");
    var followedList=(List<User>)request.getAttribute("followedList");
 %>
<!DOCTYPE html>
<html>
    <head>
        <title>Profilo di @<%= selectedUser.getUsername()%> - @<%= user.getUsername() %></title>
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
                    <section class="followers">
                        <div class="followers-header">
                            <h2>Followers</h2>
                            <span><%= followerList.size() %></span>
                        </div>
                        <div class="list-container">
                            <div class="followers-list">
                                <% for (var f: followerList) { %>
                                    <a href="<%= request.getContextPath() %>/following?id=<%= f.getId() %>&loggedId=<%= user.getId() %>"><p>@<b><%= f.getUsername() %></b></p></a>
                                <% } %>
                            </div>
                        </div>
                    </section>
                    <section class="followed">
                        <div class="followers-header">
                            <h2>Following</h2>
                            <span><%= followedList.size() %></span>
                        </div>
                        <div class="list-container" style="">
                            <div class="followers-list">
                                <% for (var f: followedList) { %>
                                    <a href="<%= request.getContextPath() %>/following?id=<%= f.getId() %>&loggedId=<%= user.getId() %>"><p>@<b><%= f.getUsername() %></b></p></a>
                                <% } %>
                            </div>
                        </div>
                    </section>
                </section>
                <% if (user.getId()!=selectedUser.getId()) { %><a href="<%= request.getContextPath() %>/follow?id=<%= user.getId() %>&followedId=<%= selectedUser.getId() %>"><button class="segui-button">Segui</button></a><% } %>
            </div>
        </section>
    </body>
</html>