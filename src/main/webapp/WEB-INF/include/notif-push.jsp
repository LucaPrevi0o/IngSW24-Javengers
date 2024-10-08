<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- JSP che si occupa della ricezione e display delle notifiche push --%>
<% var currentUser=(User)request.getAttribute("user"); %>
<link rel="stylesheet" href="../../css/notif-push.css" type="text/css" media="screen">
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.4.0/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script language="javascript">

    /* Stabilimento di una connessione WebSocket per ricevere messaggi */
    var socket = new SockJS('/ws');
    var stompClient = Stomp.over(socket);
    stompClient.connect({}, function(frame) {

        console.log(frame);
        /* Iscrizione ad un canale personalizzato in base all'id dell'utente, la funzione viene eseguita quando si riceve un messaggio */
        stompClient.subscribe('/private/'+ <%= currentUser.getId() %> +'/messages', function(result) {

            /* Parsing del contenuto del messaggio ricevuto */
            var jsonData = JSON.parse(result.body);

            /* Creazione della notifica push */
            let newNotif = document.createElement("li");
            newNotif.className = "push-notif-container";
            newNotif.id = "push-notif-" + jsonData.id;

            newNotif.innerHTML = `
                <div class="push-notif-content">
                    <p>Nuova notifica -
                        <a href=\"<%= request.getContextPath() %>/userProfile?id=` + jsonData.userSrc.id + `&loggedId=<%= currentUser.getId() %>\">
                            @<b id="username-push">`+jsonData.userSrc.username +`</b>
                        </a>
                    </p>
                    <div class="push-notif-details">
                        <a href=\" <%= request.getContextPath() %> /notifclick?id=` + jsonData.id + `&userId=<%= currentUser.getId() %>\">
                            <p style="font-size: 21px;"><b style="color: cornflowerblue">`+ jsonData.notificationType + `</b></p>
                            <p style="font-size: 20px;">`+ jsonData.notificationMsg +`</p>
                        </a>
                    </div>
                    <p>`+ jsonData.notificationDate +` - `+ jsonData.notificationTime +`</p>
                </div>
                <div onclick="closeNotification(`+ jsonData.id +`)" class="close-push-notif">
                    <img src="../../images/cross.png" alt="Close" height="20" width="20"/>
                </div>
            `;

            /* Quando ricevo una notifica push viene riprodotto un jingle e si chiude dopo 10 secondi */
            var audio = new Audio("../../sounds/notif.mp3");
            audio.play();
            setTimeout(() => closeNotification(jsonData.id), 10000);

            /* Aggiungo la notifica push a push-notif-list */
            document.getElementById("push-notif-list").prepend(newNotif);

            /* Aggiungo la notifica alla campanella */
            let notificaBell = document.createElement("li");
            notificaBell.className = "notifica da-leggere";
            notificaBell.innerHTML = `
                <a href="<%= request.getContextPath() %>/notifclick?id=` + jsonData.id + `&userId=<%= currentUser.getId() %>">
                    <div style="display: flex; flex-direction: row; align-items: center;">
                        <div class="notif-details">
                            <p>
                                <img src="../../images/icons/` + jsonData.notificationType + `.png" width="15" height="15">
                                - @<b style="color: brown">` + jsonData.userSrc.username + `</b>:
                            </p>
                            <hr style="margin-bottom: 5px; margin-top: 2px">
                            <p>` + jsonData.notificationMsg + `</p>
                        </div>
                    </div>
                <span class="data-ora">` + jsonData.notificationDate + ` - ` + jsonData.notificationTime + `</span>
                </a>
            `;

            document.getElementById("vedi-tutto-container").after(notificaBell);

            /* Aggiorno il counter della campanella */
            notifCounter++;
            document.getElementById("notif-bell-number").innerHTML = `<span>`+ notifCounter +`</span>`;
            /* In caso la campanella era vuota rimetto il display del numero di notifiche e tolgo "Nessuna nuova notifica" */
            document.getElementById("notif-bell-number").style.display = "flex";
            if(document.getElementById("no-new-notif")) document.getElementById("no-new-notif").style.display = "none";


            /* Se sono nella jsp notifiche aggiungo la notifica in cima */
            /* Aggiungo categoria "adesso" */
            if(document.getElementById("lista-notifiche")) {
                let adesso = document.getElementById("adesso");

                if(!adesso){
                    adesso = document.createElement("li");
                    adesso.id = "adesso";
                    adesso.className = "giorno";
                    adesso.innerHTML = `<p>Adesso</p>`;
                    document.getElementById("lista-notifiche").prepend(adesso);
                }

                /* Aggiungo notifica in cima */
                let notifica = document.createElement("li");
                notifica.innerHTML = `
                <li class="notif-container"  tipoNotifica="`+ jsonData.notificationType +`" usernameSrc="`+ jsonData.userSrc.username +`" contenutoNotifica="`+ jsonData.notificationMsg +`">
                    <div class="notifica">
                        <div class="da-leggere notif-wrapper">
                            <div>
                                <a href="<%= request.getContextPath() %>/userProfile?id=`+ jsonData.userSrc.id +`&loggedId=<%= currentUser.getId() %>" style="display: inline-block"><img src="../../images/propic.jpg" alt="immagine profilo" width="50" height="50"/></a>
                            </div>
                            <div class="notif-content">
                                <a href="<%= request.getContextPath() %>/userProfile?id=`+ jsonData.userSrc.id +`&loggedId=<%= currentUser.getId() %>"><p class="username">@<b style="color: brown">`+ jsonData.userSrc.username +`</b>:</p></a>
                                <hr style="margin-bottom: 5px; margin-top: 2px">
                                <a href="<%= request.getContextPath() %>/notifclick?id=`+ jsonData.id +`&userId=<%= currentUser.getId() %>">
                                    <div class="notif-details">
                                        <p style="color: cornflowerblue"><b>`+ jsonData.notificationType +`</b></p>
                                        <p>`+ jsonData.notificationMsg +`</p>
                                    </div>
                                </a>
                                <span class="ora">`+ jsonData.notificationDate +` - `+ jsonData.notificationTime +`</span>
                            </div>
                        </div>
                    </div>
                    <img class="da-leggere-icon" src="../../images/1268.png" alt="da-leggere" height="25" width="25"/>
                </li>
                `;

                adesso.after(notifica);
            }

        });
    });

    /* Funzione per chiudere la notifica quando si clicca sull'icona a forma di croce */
    function closeNotification(id){
        document.getElementById("push-notif-" + id).style.display = "none";
    }

</script>
<ul id="push-notif-list">
</ul>