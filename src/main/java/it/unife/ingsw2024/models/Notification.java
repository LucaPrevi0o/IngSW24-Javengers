package it.unife.ingsw2024.models;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name="NOTIFICATIONS")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Notification {

    @Id private int id; // notification unique id
    @OneToOne private User userSrc, userDst; //reference to User objects: the User account that generates the notification, the User account that receives the notification
    private String notificationMsg; //notification content
    private boolean viewed; //reference for viewed notifications

    //send a generic notification to a specific user
    public static Notification send(int id, User userSrc, User userDst, String notificationMsg) { return new Notification(id, userSrc, userDst, notificationMsg, false); }
}
