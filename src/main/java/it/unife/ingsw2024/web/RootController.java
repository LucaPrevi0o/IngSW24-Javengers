package it.unife.ingsw2024.web;

import it.unife.ingsw2024.models.Notification;
import it.unife.ingsw2024.repositories.NotificationRepository;
import it.unife.ingsw2024.services.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;


import java.util.List;
import java.util.Optional;

@Controller
public class RootController {

    @Autowired NotificationService myService;

    @RequestMapping("/")
    public String helloWorld() { return "hello"; }

    @RequestMapping("/getbyuserdstidtest")
    public String getbyname(Model model, @RequestParam int id) {

        List<Notification> notifications=this.myService.getALlByUserDSTId(id);
        System.out.println("Notifiche: " + notifications);
        model.addAttribute("notifications", notifications);
        return "notifiche";
    }

    @RequestMapping("/notifiche")
    public String notifiche(Model model) {

        List<Notification> notifications = this.myService.getAll();
        System.out.println("Notifiche: " + notifications);
        model.addAttribute("notifications", notifications);
        return "notifiche";
    }

    @RequestMapping("/notifclick")
    public String viewandredirect(@RequestParam int id, Model model)  {

        int nottype=0;
        Notification notifToUpdate = this.myService.getById(id);
        notifToUpdate.setViewed(true);
        this.myService.insert(notifToUpdate);
        if(nottype==0) return notifiche(model);
        else return "notifiche";
    }

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