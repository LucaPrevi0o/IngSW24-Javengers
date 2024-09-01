package it.unife.ingsw2024.models;

import jakarta.persistence.*;
import lombok.*;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.LinkedHashSet;
import java.util.Set;

@Entity
@Table(name="NOTIFICATIONS")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Notification {

    @Id private int id; //notification unique id (auto-incremented value)
    private int userSrc; //reference to User account that generates the notification
    private int userDst; //reference to User account that receives the notification
    private String notificationMsg; //notification content
    private Date notificationDate; //notification date reference
    private Time notificationTime; //notification date reference
    private boolean viewed; //reference for viewed notifications

    //send a generic notification to a specific user (timestamp is automatically set to the current time)
    /*public static Notification send(User userSrc, User userDst, String notificationMsg) { return new Notification(userSrc, userDst, notificationMsg, Date.valueOf(LocalDate.now()), Time.valueOf(LocalTime.now())); }

    public Notification(@NonNull User userSrc, @NonNull User userDst, String notificationMsg, @NonNull Date notificationDate, @NonNull Time notificationTime) {

        this.userSrc=userSrc;
        this.userDst=userDst;
        this.notificationMsg=notificationMsg;
        this.notificationDate=notificationDate;
        this.notificationTime=notificationTime;
    }
*/}
