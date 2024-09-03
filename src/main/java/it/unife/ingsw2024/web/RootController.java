package it.unife.ingsw2024.web;

import it.unife.ingsw2024.models.Notification;
import it.unife.ingsw2024.services.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;


import java.util.List;

@Controller public class RootController {

    @Autowired NotificationService notificationService;

    @RequestMapping("/")
    public String helloWorld() { return "hello"; }

    @RequestMapping("/getbyuserdstidtest")
    public String getbyname(Model model, @RequestParam int id) {

        List<Notification> notifications=this.notificationService.getALlByUserDSTId(id);
        System.out.println("Notifiche: "+notifications);
        model.addAttribute("notifications", notifications);
        return "notifiche";
    }

    @RequestMapping("/notifiche")
    public String notifiche(Model model) {

        List<Notification> notifications=this.notificationService.getAll();
        System.out.println("Notifiche: "+notifications);
        model.addAttribute("notifications", notifications);
        return "notifiche";
    }

    @RequestMapping("/notifclick")
    public String viewandredirect(Model model, @RequestParam int id)  {

        int nottype=0;
        Notification toUpdate=this.notificationService.getById(id);
        toUpdate.setViewed(true);
        this.notificationService.insert(toUpdate);
        if (nottype==0) return notifiche(model);
        return "notifiche";
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