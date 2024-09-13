package it.unife.ingsw2024.web;

import it.unife.ingsw2024.models.Notification;
import it.unife.ingsw2024.models.User;
import it.unife.ingsw2024.services.NotificationService;
import it.unife.ingsw2024.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;
import org.springframework.messaging.Message;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import java.util.List;

@Controller public class RootController {

    @Autowired NotificationService notificationService; //service per gestione notifiche
    @Autowired UserService userService; //service per gestione utenti
    @Autowired SimpMessagingTemplate simpMessagingTemplate; //template per gestione notifiche push

    //funzione di controllo per verificare se l'utente destinatario può ricevere la notifica
    private boolean isNotificationReceivable(int usrDstId, Notification n) {

        var userPref=this.notificationService.getUserPreferences(usrDstId);
        var blockedUsersList=this.userService.getBlockedUsersList(usrDstId);
        return !blockedUsersList.contains(n.getUserSrc()) && ( //controllo per verificare che l'utente non sia bloccato
            n.getNotificationType()==0 && userPref.isMessages() || //controllo preferenze sulle categorie di notifiche
            n.getNotificationType()==1 && userPref.isFollowers() ||
            n.getNotificationType()==2 && userPref.isEvents() ||
            n.getNotificationType()==3 && userPref.isPayments());
    }

    //da cancellare
    @MessageMapping("/application")
    @SendTo("/all/messages")
    public Message send(final Message message) { return message; } //

    //da cancellare
    /*@MessageMapping("/application/{userId}")
    @SendTo("/private/{userId}/messages")
    public Message sendToUser(@DestinationVariable String userId, final Message message) throws Exception {

        var usrDstId=Integer.parseInt(userId);

        *//* Decodifico il body del messaggio che contiene la notifica *//*
        var payload = new String((byte[]) message.getPayload()); //oggetto di tipo Json che contiene attributi specificati in sendNotificaTest.jsp

        *//* Creo la notifica da aggiungere al database decodificandola con Jackson in un oggetto di tipo Notifica *//*
        var objectMapper = new ObjectMapper();
        objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        var notification = objectMapper.readValue(payload, Notification.class);

        *//* Inserisco userDst all'interno della notifica *//*
        var userDst = this.userService.getUserById(usrDstId);
        notification.setUserDst(userDst);


        if (isNotificationReceivable(usrDstId, notification)) {

            System.out.println("posso inviare la notifica");

            *//* Aggiungo la notifica al db *//*
            var insertedNotification = this.notificationService.insert(notification);;

            // Converto insertedNotification in un array di bytes in formato Json
            var updatedPayload = objectMapper.writeValueAsBytes(insertedNotification);

            *//* Creo il messaggio con la notifica aggiornata *//*
            var headers = message.getHeaders();
            var updatedMessage = new GenericMessage<>(updatedPayload, headers);

            System.out.println("Messaggio aggiornato: " + updatedPayload);
            return updatedMessage;
        } else return null;
    }*/

    //da cancellare
    @RequestMapping("/sendNotifica")
    public String sendNotificaTest(Model model, @RequestParam int id) {

        var user=this.userService.getUserById(id);
        model.addAttribute("user", user);
        return "sendNotificaTest";
    }

    @RequestMapping("/deleteAllRead")
    public ModelAndView deleteAllRead(@RequestParam int id) {

        this.notificationService.deleteAllRead(id); //eliminazione di tutte le notifiche già lette
        var redirectView=new RedirectView("/getByUserId?id="+id);
        return new ModelAndView(redirectView); //redirection alla pagina notifiche aggiornata
    }

    @RequestMapping("/getByUserId")
    public String getByUserId(Model model, @RequestParam int id) {

        var notifications=this.notificationService.getAllByUserDstId(id); //lettura lista notifiche indirizzate all'utente loggato
        notifications.removeIf(n -> !isNotificationReceivable(id, n)); //cancellazione notifiche non visualizzabili
        var user=this.userService.getUserById(id); //utente loggato
        model.addAttribute("notifications", notifications);
        model.addAttribute("user", user);
        return "notifiche"; //redirection alla jsp "notifiche.jsp"
    }

    @RequestMapping("/setAllAsRead")
    public ModelAndView setAllAsRead(@RequestParam int id) {

        var notifications=this.notificationService.getAllByUserDstId(id); //lettura lista notifiche indirizzate all'utente loggato
        for (var n: notifications) n.setViewed(true); //aggiornamento stato di lettura di ogni notifica
        this.notificationService.insertAll(notifications); //aggiornamento notifiche all'interno del database
        var redirectView=new RedirectView("/getByUserId?id="+id);
        return new ModelAndView(redirectView); //redirection alla pagina notifiche aggiornata
    }

    @RequestMapping("/follow")
    public ModelAndView followProfile(@RequestParam int id, @RequestParam int followedId) {

        var userSrc=this.userService.getUserById(id); //utente loggato
        var userDst=this.userService.getUserById(followedId); //nuovo utente seguito dall'utente loggato
        var blockedUsers=this.userService.getBlockedUsersList(followedId); //lista utenti bloccati dall'utente seguito
        if (!blockedUsers.contains(userSrc)) { //il following del profilo è consentito solamente se l'utente seguito non ha bloccato l'utente loggato

            this.userService.follow(id, followedId); //aggiungi nuovo follower
            this.notificationService.sendNotification(userSrc, userDst, 1, "@<b>"+userSrc.getUsername()+"</b> ha cominciato a seguirti"); //invia notifica
        }
        var redirectView=new RedirectView("/following?id="+followedId+"&loggedId="+id);
        return new ModelAndView(redirectView); //redirection alla pagina profilo dell'utente seguito
    }

    @RequestMapping("/settings")
    public String settings(Model model, @RequestParam int id) {

        var user=this.userService.getUserById(id); //utente loggato
        var blockedUsers=this.userService.getBlockedUsersList(id); //lista utenti bloccati dell'utente bloccato
        var notifications=this.notificationService.getAllByUserDstId(id); //lettura lista notifiche indirizzate all'utente loggato
        var notifPref=this.notificationService.getUserPreferences(id).asList(); //lista preferenze notifiche utente loggato
        model.addAttribute("notifications", notifications);
        model.addAttribute("user", user);
        model.addAttribute("blockedUsers", blockedUsers);
        model.addAttribute("userPreferences", notifPref);
        return "settings"; //redirection alla jsp "settings.jsp"
    }

    @RequestMapping("/updateSettings")
    public ModelAndView updateSettings(@RequestParam int id, @RequestParam boolean messages, @RequestParam boolean followers, @RequestParam boolean events, @RequestParam boolean payments) {

        this.notificationService.updatePreferences(id, new boolean[]{messages, followers, events, payments}); //aggiornamento preferenze notifiche utente
        var redirectView=new RedirectView("/settings?id="+id);
        return new ModelAndView(redirectView); //redirection alla pagina impostazioni profilo aggiornata
    }

    @RequestMapping("/unfollow")
    public ModelAndView unfollowProfile(@RequestParam int id, @RequestParam int followedId) {

        this.userService.unfollow(id, followedId); //rimozione following profilo utente
        var redirectView=new RedirectView("/following?id="+followedId+"&loggedId="+id);
        return new ModelAndView(redirectView); //redirection alla pagina profilo utente aggiornata
    }

    @RequestMapping("/notifclick")
    public ModelAndView viewandredirect(@RequestParam int id, @RequestParam int userId)  {

        var toUpdate=this.notificationService.getById(id); //lettura notifica in base a id
        toUpdate.setViewed(true); //aggiornamento stato di lettura
        this.notificationService.insert(toUpdate); //aggiornamento notifica letta
        var redirectView=new RedirectView("/getByUserId?id="+userId);
        return new ModelAndView(redirectView); //redirection alla pagina notifiche aggiornata
    }

    @RequestMapping("/block")
    public ModelAndView block(@RequestParam int blockedId, @RequestParam int userId)  {

        this.userService.unfollow(userId, blockedId); //rimozione following utente bloccato (quando l'utente viene bloccato perde in automatico il following dell'utente loggato)
        this.userService.block(blockedId, userId); //aggiornamento stato di blocco dell'utente
        var redirectView=new RedirectView("/settings?id="+userId);
        return new ModelAndView(redirectView); //redirection alla pagina impostazioni profilo con lista utenti bloccati aggiornata
    }

    @RequestMapping("/unblock")
    public ModelAndView unblock(@RequestParam int blockedId, @RequestParam int userId)  {

        this.userService.unblock(blockedId, userId); //rimozione blocco utente
        var redirectView=new RedirectView("/settings?id="+userId);
        return new ModelAndView(redirectView); //redirection alla pagina impostazioni profilo con lista utenti bloccati aggiornata
    }

    @RequestMapping("/following")
    public String following(Model model, @RequestParam int id, @RequestParam int loggedId) {

        var notifications=this.notificationService.getAllByUserDstId(loggedId); //lista notifiche utente loggato
        var selectedUser=this.userService.getUserById(id); //utente cercato nella pagina profilo
        var user=this.userService.getUserById(loggedId); //utente loggato
        var followerList=this.userService.getFollowerList(id); //lista follower utente cercato
        var followedList=this.userService.getFollowedList(id); //lista utenti seguiti utente cercato
        var blockedUsers=this.userService.getBlockedUsersList(loggedId); //lista utenti bloccati utente loggato
        model.addAttribute("notifications", notifications);
        model.addAttribute("selectedUser", selectedUser);
        model.addAttribute("user", user);
        model.addAttribute("followerList", followerList);
        model.addAttribute("followedList", followedList);
        model.addAttribute("blockedUsers", blockedUsers);
        return "following"; //redirection alla jsp "following.jso"
    }
}