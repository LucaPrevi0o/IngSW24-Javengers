package it.unife.ingsw2024.web;

import it.unife.ingsw2024.models.Notification;
import it.unife.ingsw2024.services.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;


import java.util.List;
import java.util.Optional;

@Controller
public class RootController {

    @Autowired
    NotificationService myService;

    @RequestMapping("/")
    public String helloWorld() { return "hello"; }

    @RequestMapping("/notifiche")
    public void notifiche(Model model) {
        List<Notification> notifications = this.myService.getAll();
        System.out.println("Notifiche: " + notifications);
        model.addAttribute("notifications", notifications);
        //return "notifiche";
    }

    @RequestMapping("/notifclick")
    public void  viewandredirect(int id)
    {
        //redirect yet to do, just simulating viewed notification behaviour as for now
        Notification notifToUpdate = this.myService.getById(id);
        System.out.println("viewed before:" + notifToUpdate.isViewed()+"\n");
        System.out.println("notifToUpdate befediting: "+notifToUpdate+ "\n");
        notifToUpdate.setViewed(true);
        System.out.println("viewed after:" + notifToUpdate.isViewed()+"\n");
        System.out.println("notifToUpdate afediting: "+notifToUpdate+ "\n");


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