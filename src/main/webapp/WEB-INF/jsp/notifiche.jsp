<%@ page import="it.unife.ingsw2024.models.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% var loggedAccount=(User)request.getAttribute("loggedAccount"); %>
<!DOCTYPE html>
<html>
<head>
    <title>Notifiche</title>
    <link rel="stylesheet" href="../../css/notifiche.css" type="text/css" media="screen">
    <script language="javascript">

        function removeRead() {
            Array.from(document.querySelectorAll('.da-leggere')).forEach(
                (item) => {
                    item.classList.remove('da-leggere');
                }
            );

            document.querySelectorAll('.da-leggere-icon').forEach(icon => icon.remove());
        }

        function onLoadHandler() {
            document.getElementById("read-button").addEventListener("click", removeRead);
        }

        window.addEventListener("load", onLoadHandler);

    </script>
</head>
<body>
<nav class="sidebar">
    <h1>Notifiche</h1>
    <ul>
        <li class="notif"><a href=""><span>Notifiche</span></a></li>
        <li class="settings"><a href=""><span>Impostazioni</span></a></li>
    </ul>
</nav>
<section class="content">
    <%@include file="../include/notif-bell.inc"%>
    <button id="read-button">Segna tutto come letto</button>
    <ul class="lista-notifiche">
        <li class="giorno"><p>Oggi</p></li>
        <li class="notif-container">
            <div class="notifica">
                <a class="da-leggere" href="">
                    <img src="../../images/propic.jpg" alt="immagine profilo" width="50" height="50"/>
                    <div class="notif-content">
                        <div class="notif-details">
                            <p>Mario si è iscritto al tuo evento</p>
                        </div>
                        <span class="ora">13:45</span>
                    </div>
                </a>
            </div>
        <img class="da-leggere-icon" src="../../images/1268.png" alt="da-leggere" height="25" width="25"/>
        </li>
        <li class="giorno"><p>Ieri</p></li>
        <li class="notif-container">
            <div class="notifica">
                <a href="">
                    <img src="../../images/propic.jpg" alt="immagine profilo" width="50" height="50"/>
                    <div class="notif-content">
                        <div class="notif-details">
                            <p>Mario si è iscritto al tuo evento</p>
                        </div>
                        <span class="ora">13:45</span>
                    </div>
                </a>
            </div>
        </li>
    </ul>
</section>
</body>
</html>