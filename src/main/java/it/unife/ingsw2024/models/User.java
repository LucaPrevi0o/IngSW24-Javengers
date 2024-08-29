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

    //mark all notifications as read - set all notification as not read
    public void readAll() { for (var notification: recentNotifications) notification.setViewed(true); }
    public void unreadAll() { for (var notification: recentNotifications) notification.setViewed(false); }

    //delete every viewed notifications from recent list
    public void deleteReadNotifications() { recentNotifications.removeIf(Notification::isViewed); }

    //follow/unfollow an account
    public void follow(User user) { followers.add(user); }
    public void unfollow(User user) { followers.remove(user); }

    //receive a generic notification
    public void receiveNotification(Notification notification) { recentNotifications.add(notification); }
}
