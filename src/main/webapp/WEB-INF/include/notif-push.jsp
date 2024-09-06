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
        console.log(frame);
        stompClient.subscribe('/all/messages', function(result) {
            let newNotif = document.createElement("li");
            newNotif.className = "push-notif-container";
            newNotif.id = "push-notif-" + id;

            newNotif.innerHTML = `
                <div class="push-notif-content">
                    <p>aaa</p>
                    <div class="push-notif-details"><p>aaa</p></div>
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