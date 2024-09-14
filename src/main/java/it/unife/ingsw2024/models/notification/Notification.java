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

    @Id @Column(name="id") @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id; //id notifica (auto-generato)

    @ManyToOne @JoinColumn(name="UserSRC", referencedColumnName="id")
    private User userSrc; //id utente che invia la notifica

    @ManyToOne @JoinColumn(name="UserDST", referencedColumnName="id")
    private User userDst; //id utente che riceve la notifica

    @Column(name="NotificationMessage")
    private String notificationMsg; //messaggio notifica

    @Column(name="NotificationDate")
    private Date notificationDate; //data di invio notifica

    @Column(name="NotificationTime")
    private Time notificationTime; //ora di invio notifica

    @Enumerated(value=EnumType.STRING) @Column(name="NotificationType")
    private NotificationType notificationType; //tipo notifica

    @Column(name="Viewed", columnDefinition="TINYINT(1)")
    private boolean viewed; //stato visualizzazione notifica
}

