package it.unife.ingsw2024.web;

import it.unife.ingsw2024.models.Notification;
import it.unife.ingsw2024.services.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;


import java.util.List;

@Controller
public class RootController {

    @Autowired
    NotificationService myService;

    @RequestMapping("/")
    public String helloWorld() { return "hello"; }

    @RequestMapping("/notifiche")
    public String notifiche(Model model) {
        System.out.println("Notifiche: " + this.myService.getAll());
       /* model.addAttribute("notifications", this.myService.getAllByUserId(463));*/
        model.addAttribute("notifications", this.myService.getAll());
        return "notifiche"; }

    @RequestMapping("/2nd")
    public String secondSubPage() { return "test/list"; }

    @RequestMapping({"/testMysql"})
    public String testMysql(Model model) {

        model.addAttribute("test", this.myService.getAll());
        return "testMysql";
    }

    @RequestMapping({"/testWithElements"})
    public List<Notification> addElements() { return this.myService.addElements(); }
}