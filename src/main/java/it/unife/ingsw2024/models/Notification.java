package it.unife.ingsw2024.models;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@Entity
@Table(name="NOTIFICATIONS")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Notification {

    @Id private int id; //notification unique id (i still don't know for sure how to implement the fact that it's automatically set like in MySQL)
    @OneToOne private User userSrc, userDst; //reference to User objects: the User account that generates the notification, the User account that receives the notification
    private String notificationMsg; //notification content
    private Timestamp notificationDate; //notification date/time reference
    private boolean viewed; //reference for viewed notifications

    //send a generic notification to a specific user (timestamp is automatically set to the current time)
    public static Notification send(int id, User userSrc, User userDst, String notificationMsg) { return new Notification(id, userSrc, userDst, notificationMsg, Timestamp.valueOf(LocalDateTime.now()), false); }
}
