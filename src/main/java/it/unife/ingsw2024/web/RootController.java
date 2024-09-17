package it.unife.ingsw2024.web;

import it.unife.ingsw2024.models.notification.NotificationType;
import it.unife.ingsw2024.services.NotificationService;
import it.unife.ingsw2024.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;
import org.springframework.messaging.simp.SimpMessagingTemplate;

@Controller public class RootController {

    @Autowired NotificationService notificationService; //service per gestione notifiche
    @Autowired UserService userService; //service per gestione utenti
    @Autowired SimpMessagingTemplate simpMessagingTemplate; //template per gestione notifiche push

    @RequestMapping("/deleteAllRead")
    public ModelAndView deleteAllRead(@RequestParam int id) {

        this.notificationService.deleteAllRead(id); //eliminazione di tutte le notifiche già lette
        var redirectView=new RedirectView("/getByUserId?id="+id);
        return new ModelAndView(redirectView); //redirection alla pagina notifiche aggiornata
    }

    @RequestMapping("/getByUserId")
    public String getByUserId(Model model, @RequestParam int id) {

        var notifications=this.notificationService.getAllByUserDstId(id); //lettura lista notifiche indirizzate all'utente loggato
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
        if (!blockedUsers.contains(userSrc)) { //il userProfile del profilo è consentito solamente se l'utente seguito non ha bloccato l'utente loggato

            this.userService.follow(id, followedId); //aggiungi nuovo follower
            this.notificationService.sendNotification(userSrc, userDst, NotificationType.FOLLOWERS, "@<b>"+userSrc.getUsername()+"</b> ha cominciato a seguirti"); //invia notifica
        }

        var redirectView=new RedirectView("/userProfile?id="+followedId+"&loggedId="+id);
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

        this.userService.unfollow(id, followedId); //rimozione userProfile profilo utente
        var redirectView=new RedirectView("/userProfile?id="+followedId+"&loggedId="+id);
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

        this.userService.unfollow(userId, blockedId); //rimozione userProfile reciproco
        this.userService.unfollow(blockedId, userId);
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

    @RequestMapping("/userProfile")
    public String userProfile(Model model, @RequestParam int id, @RequestParam int loggedId) {

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
        return "user-profile"; //redirection alla jsp "user-profile.jso"
    }

    @RequestMapping("/")
    public String welcome() { return "welcome"; }
}