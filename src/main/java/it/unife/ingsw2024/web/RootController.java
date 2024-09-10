package it.unife.ingsw2024.web;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import it.unife.ingsw2024.models.Notification;
import it.unife.ingsw2024.models.User;
import it.unife.ingsw2024.services.NotificationService;
import it.unife.ingsw2024.services.UserService;
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

    @MessageMapping("/application")
    @SendTo("/all/messages")
    public Message send(final Message message) throws Exception { return message; }

    @MessageMapping("/application/{userId}")
    @SendTo("/private/{userId}/messages")
    public Message sendToUser(@DestinationVariable String userId, final Message message) throws Exception {

        /* Decodifico il body del messaggio che contiene la notifica */
        String payload = new String((byte[]) message.getPayload()); //oggetto di tipo Json che contiene attributi specificati in sendNotificaTest.jsp

        /* Creo la notifica da aggiungere al database decodificandola con Jackson in un oggetto di tipo Notifica */
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        Notification notification = objectMapper.readValue(payload, Notification.class);

        /* Inserisco userDst e userSrc */
        User userDst = this.userService.getUserById(Integer.parseInt(userId));
        User userSrc = null;

        /* UserSrc lo ottengo dall'attributo userSrcId salvato nell'oggetto Json */
        JsonNode rootNode = objectMapper.readTree(payload);
        JsonNode userSrcIdNode = rootNode.get("userSrcId");
        if (userSrcIdNode != null) {
            int userSrcId = userSrcIdNode.asInt();
            userSrc = this.userService.getUserById(userSrcId);
        }

        notification.setUserDst(userDst);
        notification.setUserSrc(userSrc);

        /* Aggiungo la notifica al db */
        Notification insertedNotification = this.notificationService.insert(notification);
        int insNotifId = insertedNotification.getId();

        // Faccio il parsing del payload in un JsonNode per aggiungere insNotifId
        ObjectNode updatedPayloadNode = (ObjectNode) rootNode;
        updatedPayloadNode.put("insNotifId", insNotifId);
        String updatedPayload = objectMapper.writeValueAsString(updatedPayloadNode);

        /* Creo il messaggio aggiornato con l'insNotifId */
        MessageHeaders headers = message.getHeaders();
        Message updatedMessage = new GenericMessage<>(updatedPayload.getBytes(), headers);

        System.out.println("Messaggio aggiornato: " + updatedPayload);

        return updatedMessage;
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
        var userPref=this.notificationService.getUserPreferences(id);
        notifications.removeIf(n -> n.getNotificationType()==0 && !userPref.isMessages() ||
                                    n.getNotificationType()==1 && !userPref.isFollowers() ||
                                    n.getNotificationType()==2 && !userPref.isEvents() ||
                                    n.getNotificationType()==3 && !userPref.isPayments());
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