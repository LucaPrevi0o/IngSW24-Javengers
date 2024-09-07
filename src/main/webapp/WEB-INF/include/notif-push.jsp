<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="../../css/notif-push.css" type="text/css" media="screen">
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.4.0/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script language="javascript">
    var stompClient = null;
    var id = 1;

    var socket = new SockJS('/ws');
    stompClient = Stomp.over(socket);
    stompClient.connect({}, function(frame) {

        function getLiteralType(testVal) {

            testVal++;
            testVal--;
            if (testVal===0) return "Eventi";
            else if (testVal===1) return "Follower";
            else if (testVal===2) return "Messaggi";
            else if (testVal===3) return "Pagamenti";
        }

        console.log(frame);
        stompClient.subscribe('/private/'+ <%= user.getId() %> +'/messages', function(result) {

            let newNotif = document.createElement("li");
            newNotif.className = "push-notif-container";
            newNotif.id = "push-notif-" + id;
            var resultBody = JSON.parse(result.body);
            var payload = atob(resultBody.payload);
            var jsonData = JSON.parse(payload);

            newNotif.innerHTML = `
                <div class="push-notif-content">
                    <p>`+ jsonData.title +` -
                        <a href=\"<%= request.getContextPath() %>/following?id=` + jsonData.userSrcId + `&loggedId=<%= user.getId() %>\">
                            @<b style="color: brown">`+jsonData.usernameSrc+`</b>
                        </a>
                    </p>
                    <div class="push-notif-details">
                        <a href=\" <%= request.getContextPath() %> /notifclick?id=` + id + `&userId=<%= user.getId() %>\">
                            <p><b style="color: cornflowerblue">`+ getLiteralType(jsonData.notificationType)+ `</b></p>
                            <p>`+ jsonData.notificationMsg +`</p>
                        </a>
                    </div>
                    <p>`+ jsonData.notificationDate +` - `+ jsonData.notificationTime +`</p>
                </div>
                <div onclick="closeNotification(`+ id +`)" class="close-push-notif">
                    <img src="../../images/cross.png" alt="Close" height="20" width="20"/>
                </div>
            `;

            document.getElementById("push-notif-list").prepend(newNotif);
            id++;
        });
    });

    function closeNotification(id){

        console.log("id: " + id);
        document.getElementById("push-notif-" + id).style.display = "none";
    }

</script>
<ul id="push-notif-list">


</ul>