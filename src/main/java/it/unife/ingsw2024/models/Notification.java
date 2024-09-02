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

    @Id
    @Column(name = "id")
    private int id; //notification unique id (auto-incremented value)

    @Column(name = "UserSRC")
    private int UserSrc; //reference to User account that generates the notification

    @Column(name = "UserDST")
    private int UserDst; //reference to User account that receives the notification

    @Column(name = "NotificationMessage")
    private String NotificationMsg; //notification content

    @Column(name = "NotificationDate")
    private Date NotificationDate; //notification date reference

    @Column(name = "NotificationTime")
    private Time notificationTime; //notification date reference

    @Column(name = "Viewed", columnDefinition = "TINYINT(1)")
    private boolean Viewed; //reference for viewed notifications

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
