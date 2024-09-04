<%@ page import="it.unife.ingsw2024.models.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    var selectedUser =(User) request.getAttribute("selectedUser");
    var followersNumber =(Integer) request.getAttribute("followersNumber");
    var followingNumber =(Integer) request.getAttribute("followingNumber");
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
                    <span>@<%=selectedUser.getUsername()%></span>
                </section>
            <section class="following-container">
                <div class="followers">
                    <h2>Followers</h2>
                    <span><%=followersNumber%></span>
                </div>
                <div class="followed">
                    <h2>Following</h2>
                    <span><%=followingNumber%></span>
                </div>
            </section>
            <button class="segui-button">Segui</button>
            </div>
        </section>
    </body>
</html>