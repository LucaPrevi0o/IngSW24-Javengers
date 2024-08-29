package it.unife.ingsw2024.web;

import it.unife.ingsw2024.models.Notification;
import it.unife.ingsw2024.services.MyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;


import java.util.List;

@Controller
public class RootController {

    @Autowired MyService myService;

    @RequestMapping("/")
    public String helloWorld() { return "hello"; }

    @RequestMapping("/notifiche")
    public String notifiche() { return "notifiche"; }

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