package it.unife.ingsw2024.models;

import jakarta.persistence.*;
import lombok.*;
import java.sql.Date;
import java.sql.Time;

@Entity
@Table(name="NOTIFICATIONS")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Notification {

    @Id @Column(name="id")
    private int id; //notification unique id (auto-incremented value)

    @Column(name="UserSRC")
    private int userSrc; //reference to User account id that generates the notification

    @Column(name="UserDST")
    private int UserDst; //reference to User account id that receives the notification

    @Column(name="NotificationMessage")
    private String NotificationMsg; //notification content

    @Column(name="NotificationDate")
    private Date NotificationDate; //notification date reference

    @Column(name="NotificationTime")
    private Time notificationTime; //notification date reference

    @Column(name="Viewed", columnDefinition="TINYINT(1)")
    private boolean Viewed; //reference for viewed notifications
}
