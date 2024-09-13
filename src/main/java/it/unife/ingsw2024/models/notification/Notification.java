package it.unife.ingsw2024.models.notification;

import it.unife.ingsw2024.models.User;
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
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id; //notification unique id (auto-incremented value)

    @ManyToOne
    @JoinColumn(name="UserSRC", referencedColumnName = "id")
    private User userSrc; //reference to User account id that generates the notification

    @ManyToOne
    @JoinColumn(name="UserDST", referencedColumnName = "id")
    private User userDst; //reference to User account id that receives the notification

    @Column(name="NotificationMessage")
    private String notificationMsg; //notification content

    @Column(name="NotificationDate")
    private Date notificationDate; //notification date reference

    @Column(name="NotificationTime")
    private Time notificationTime; //notification date reference

    @Enumerated(value=EnumType.STRING) @Column(name="NotificationType")
    private NotificationType notificationType; //notification type (message, follower, event subscription...)

    @Column(name="Viewed", columnDefinition="TINYINT(1)")
    private boolean viewed; //reference for viewed notifications
}

