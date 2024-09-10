package it.unife.ingsw2024.web;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import it.unife.ingsw2024.models.Notification;
import it.unife.ingsw2024.models.User;
import it.unife.ingsw2024.services.NotificationService;
import it.unife.ingsw2024.services.UserService;
import org.aspectj.weaver.ast.Not;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.MessageHeaders;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.support.GenericMessage;
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

    @Autowired NotificationService notificationService;
    @Autowired UserService userService;
    @Autowired SimpMessagingTemplate simpMessagingTemplate;

    private <T> boolean isContained(T usr, List<T> list) { return list.contains(usr); }

    private boolean isNotificationReceivable(int usrDstId, Notification n) {

        var userPref=this.notificationService.getUserPreferences(usrDstId);
        var blockedUsersList=this.userService.getBlockedUsersList(usrDstId);
        return !isContained(n.getUserSrc(), blockedUsersList) && (
            n.getNotificationType()==0 && userPref.isMessages() ||
            n.getNotificationType()==1 && userPref.isFollowers() ||
            n.getNotificationType()==2 && userPref.isEvents() ||
            n.getNotificationType()==3 && userPref.isPayments());
    }

    @MessageMapping("/application")
    @SendTo("/all/messages")
    public Message send(final Message message) throws Exception { return message; }

    @MessageMapping("/application/{userId}")
    @SendTo("/private/{userId}/messages")
    public Message sendToUser(@DestinationVariable String userId, final Message message) throws Exception {

        var usrDstId=Integer.parseInt(userId);

        /* Decodifico il body del messaggio che contiene la notifica */
        var payload = new String((byte[]) message.getPayload()); //oggetto di tipo Json che contiene attributi specificati in sendNotificaTest.jsp

        /* Creo la notifica da aggiungere al database decodificandola con Jackson in un oggetto di tipo Notifica */
        var objectMapper = new ObjectMapper();
        objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        var notification = objectMapper.readValue(payload, Notification.class);

        /* Inserisco userDst all'interno della notifica */
        var userDst = this.userService.getUserById(usrDstId);
        notification.setUserDst(userDst);


        if (isNotificationReceivable(usrDstId, notification)) {

            System.out.println("posso inviare la notifica");

            /* Aggiungo la notifica al db */
            var insertedNotification = this.notificationService.insert(notification);;

            // Converto insertedNotification in un array di bytes in formato Json
            var updatedPayload = objectMapper.writeValueAsBytes(insertedNotification);

            /* Creo il messaggio con la notifica aggiornata */
            var headers = message.getHeaders();
            var updatedMessage = new GenericMessage<>(updatedPayload, headers);

            System.out.println("Messaggio aggiornato: " + updatedPayload);
            return updatedMessage;
        } else return null;
    }

    @RequestMapping("/sendNotifica")
    public String sendNotificaTest(Model model, @RequestParam int id) {

        var user=this.userService.getUserById(id);
        model.addAttribute("user", user);
        return "sendNotificaTest";
    }

    @RequestMapping("/")
    public String helloWorld() { return "hello"; }

    @RequestMapping("/deleteAllRead")
    public ModelAndView deleteAllRead(@RequestParam int id) {

        this.notificationService.deleteAllRead(id);
        var redirectView=new RedirectView("/getByUserId?id="+id);
        return new ModelAndView(redirectView);
    }

    @RequestMapping("/getByUserId")
    public String getByUserId(Model model, @RequestParam int id) {

        var notifications=this.notificationService.getAllByUserDstId(id);
        notifications.removeIf(n -> !isNotificationReceivable(id, n));
        var user=this.userService.getUserById(id);
        model.addAttribute("notifications", notifications);
        model.addAttribute("user", user);
        return "notifiche";
    }

    @RequestMapping("/setAllAsRead")
    public ModelAndView setAllAsRead(@RequestParam int id) {

        var notifications=this.notificationService.getAllByUserDstId(id);
        for (var n: notifications) n.setViewed(true);
        this.notificationService.insertAll(notifications);

        var redirectView=new RedirectView("/getByUserId?id="+id);
        return new ModelAndView(redirectView);
    }

    @RequestMapping("/follow")
    public ModelAndView followProfile(@RequestParam int id, @RequestParam int followedId) {

        var blockedUsers=this.userService.getBlockedUsersList(followedId);
        if (!blockedUsers.contains(this.userService.getUserById(id))) this.userService.follow(id, followedId);
        var redirectView=new RedirectView("/following?id=" + followedId + "&loggedId=" + id);
        return new ModelAndView(redirectView);
    }

    @RequestMapping("/settings")
    public String settings(Model model, @RequestParam int id) {

        var user=this.userService.getUserById(id);
        var blockedUsers=this.userService.getBlockedUsersList(id);
        var notifications=this.notificationService.getAllByUserDstId(id);
        var userNotifPref=this.notificationService.getUserPreferences(id);
        var notifPref=new boolean[]{userNotifPref.isMessages(), userNotifPref.isFollowers(), userNotifPref.isEvents(), userNotifPref.isPayments()};

        model.addAttribute("notifications", notifications);
        model.addAttribute("user", user);
        model.addAttribute("blockedUsers", blockedUsers);
        model.addAttribute("userPreferences", notifPref);

        return "settings";
    }

    @RequestMapping("/updateSettings")
    public ModelAndView updateSettings(@RequestParam int id, @RequestParam boolean messages, @RequestParam boolean followers, @RequestParam boolean events, @RequestParam boolean payments) {

        this.notificationService.updatePreferences(id, new boolean[]{messages, followers, events, payments});
        var redirectView=new RedirectView("/settings?id="+id);
        return new ModelAndView(redirectView);
    }

    @RequestMapping("/unfollow")
    public ModelAndView unfollowProfile(@RequestParam int id, @RequestParam int followedId) {

        this.userService.unfollow(id, followedId);
        var redirectView=new RedirectView("/following?id=" + followedId + "&loggedId=" + id);
        return new ModelAndView(redirectView);
    }

    @RequestMapping("/notifiche")
    public String notifiche(Model model, @RequestParam int id) {

        var notifications=this.notificationService.getAll();
        var user=this.userService.getUserById(id);
        model.addAttribute("notifications", notifications);
        model.addAttribute("user", user);
        return "notifiche";
    }

    @RequestMapping("/notifclick")
    public ModelAndView viewandredirect(@RequestParam int id, @RequestParam int userId)  {

        var toUpdate=this.notificationService.getById(id);
        toUpdate.setViewed(true);
        this.notificationService.insert(toUpdate);

        var redirectView=new RedirectView("/getByUserId?id="+userId);
        return new ModelAndView(redirectView);
    }

    @RequestMapping("/block")
    public ModelAndView block(@RequestParam int blockedId, @RequestParam int userId)  {

        this.userService.block(blockedId, userId);
        var redirectView=new RedirectView("/settings?id="+userId);
        return new ModelAndView(redirectView);
    }

    @RequestMapping("/unblock")
    public ModelAndView unblock(@RequestParam int blockedId, @RequestParam int userId)  {

        this.userService.unblock(blockedId, userId);
        var redirectView=new RedirectView("/settings?id="+userId);
        return new ModelAndView(redirectView);
    }

    @RequestMapping("/following")
    public String following(Model model, @RequestParam int id, @RequestParam int loggedId) {

        /* Per la notification bell */
        var notifications=this.notificationService.getAllByUserDstId(loggedId);
        model.addAttribute("notifications", notifications);

        /* Per il display dell'username */
        var selectedUser=this.userService.getUserById(id);
        var user=this.userService.getUserById(loggedId);

        /* Per il display del numero di followers/following */
        var followerList=this.userService.getFollowerList(id);
        var followedList=this.userService.getFollowedList(id);
        model.addAttribute("selectedUser", selectedUser);
        model.addAttribute("user", user);
        model.addAttribute("followerList", followerList);
        model.addAttribute("followedList", followedList);

        /* Per il pulsante blocca/sblocca */
        var blockedUsers=this.userService.getBlockedUsersList(loggedId);
        model.addAttribute("blockedUsers", blockedUsers);

        return "following";
    }

    @RequestMapping("/2nd")
    public String secondSubPage() { return "test/list"; }

    @RequestMapping({"/testMysql"})
    public String testMysql(Model model) {

        model.addAttribute("test", this.notificationService.getAll());
        return "testMysql";
    }

    @RequestMapping({"/testWithElements"})
    public List<Notification> addElements() { return this.notificationService.addElements(); }
}