package it.unife.ingsw2024.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name="USER")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {

    @Id private int id; //unique user id
    private String username; //username
    @ManyToMany private List<User> followers, followed; //list of User followers and followed accounts
    @OneToMany private List<Notification> recentNotifications; //list of notifications received

    //if we have to make things look good, we somehow have to make a reference to a profile image to show on the web page
    //otherwise we don't have a direct user-profile image correspondence and this will hunt me to death because it looks disgusting

    // --- --- ---

    //for now this has no actual effect on the database (i think)
    //at the same time, i'm not sure if this is the best way to tackle the problem, as i don't see any direct reference to the database update and i don't think this will actually work
    //all of these function will probably have to be separated from the entity behaviour inside an actual Servlet controller (or whatever Spring uses to handle everything behind)
    //but there's also a chance that Spring actually handles database communication without explicitly creating transactions and all of that, i'm not sure

    // --- --- ---

    //mark all notifications as read - set all notification as not read
    public void readAll() { for (var notification: this.recentNotifications) notification.setViewed(true); }
    public void unreadAll() { for (var notification: this.recentNotifications) notification.setViewed(false); }

    //delete every viewed notifications from recent list
    public void deleteReadNotifications() { this.recentNotifications.removeIf(Notification::isViewed); }

    //follow an account
    public void follow(User user) {

        //notification message has to be written from the receiver's perspective
        user.receiveNotification(Notification.send(0, this, user, this.username+" has followed you"));
        this.followed.add(user); //add the followed account to the user's followed list
        user.followers.add(user); //set this account as a new follower
    }

    //follow an account
    public void unfollow(User user) {

        //notification message has to be written from the receiver's perspective
        user.receiveNotification(Notification.send(0, this, user, this.username+" has removed you from followers"));
        this.followed.add(user); //remove the followed account to the user's followed list
        user.followers.add(user); //unset this account as a follower
    }

    //send a message (this will only trigger a notification as message communication is not handled here)
    public void sendTextMessage(User user, String message) { user.receiveNotification(Notification.send(0, this, user, this.username+" has sent you a message: "+message)); }

    //receive a generic notification
    public void receiveNotification(Notification notification) { this.recentNotifications.add(notification); }
}
