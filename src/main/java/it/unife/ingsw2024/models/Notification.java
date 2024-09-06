package it.unife.ingsw2024.models;

import com.fasterxml.jackson.annotation.JsonFormat;
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

    @ManyToOne
    @JoinColumn(name="UserSRC", referencedColumnName = "id")
    private User userSrc; //reference to User account id that generates the notification

    @ManyToOne
    @JoinColumn(name="UserDST", referencedColumnName = "id")
    private User userDst; //reference to User account id that receives the notification

    @Column(name="NotificationMessage")
    private String notificationMsg; //notification content

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyy-MM-dd")
    @Column(name="NotificationDate")
    private Date notificationDate; //notification date reference

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HH:mm:ss")
    @Column(name="NotificationTime")
    private Time notificationTime; //notification date reference

    @Column(name="NotificationType")
    private int notificationType; //notification type (message, follower, event subscription...)

    @Column(name="Viewed", columnDefinition="TINYINT(1)")
    private boolean viewed; //reference for viewed notifications

    public String getNotificationLiteralType() {

        return switch (notificationType) {

            case 0 -> "Messaggi";
            case 1 -> "Follower";
            case 2 -> "Eventi";
            case 3 -> "Pagamenti";
            default -> "NULL";
        };
    }
}
