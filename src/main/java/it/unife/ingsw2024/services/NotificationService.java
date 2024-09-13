package it.unife.ingsw2024.services;

import it.unife.ingsw2024.models.notification.Notification;
import it.unife.ingsw2024.models.NotificationPreferencesMapping;
import it.unife.ingsw2024.models.notification.NotificationType;
import it.unife.ingsw2024.models.User;
import it.unife.ingsw2024.repositories.NotificationRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDateTime;
import java.util.List;

//notification service
@Service public class NotificationService {

    @Autowired private NotificationRepository notificationRepository;
    @Autowired private SimpMessagingTemplate simpMessagingTemplate;

    public Notification sendNotification(User userSrc, User userDst, NotificationType notificationType, String notificationMessage) {

        var notification = new Notification();
        var now = LocalDateTime.now();

        var date = Date.valueOf(now.toLocalDate());
        var time = Time.valueOf(now.toLocalTime());

        //Riempio la notifica con i parametri passati
        notification.setUserSrc(userSrc);
        notification.setUserDst(userDst);
        notification.setNotificationMsg(notificationMessage);
        notification.setNotificationDate(date);
        notification.setNotificationTime(time);
        notification.setNotificationType(notificationType);
        System.out.println("Notification: "+notification);

        //Aggiungo la notifica al database, mi restituisce la notifica aggiornata con l'id
        var insertedNotification = notificationRepository.save(notification);
        System.out.println("Inserted notification: "+insertedNotification);

        // Mando il messaggio a /private/userDstId/messages (la notifica viene serializzata in JSON automaticamente)
        simpMessagingTemplate.convertAndSend("/private/"+ userDst.getId() +"/messages", insertedNotification);
        System.out.println("Converted/sent notification: "+insertedNotification);

        return insertedNotification;
    }

    //return every notification registered in database
    public List<Notification> getAll() { return notificationRepository.findAll(); }

    //return a notification filtering data by id
    public Notification getById(int id) { return notificationRepository.findById(id).orElse(null); }

    //return every notification received by a specific user dst account
    public List<Notification> getAllByUserDstId(int id) { return notificationRepository.findAllByUserDst(id); }

    //insert a new notification
    @Transactional
    public Notification insert(Notification record) { return notificationRepository.save(record); }

    public void insertAll(List<Notification> recordSet) { notificationRepository.saveAll(recordSet); }

    @Transactional
    public void deleteAllRead(int id) { notificationRepository.deleteAllRead(id); }

    public NotificationPreferencesMapping getUserPreferences(int id) { return notificationRepository.findUserPreferences(id); }

    @Transactional
    public void updatePreferences(int id, boolean[] preferences) { notificationRepository.updatePreferences(id, preferences[0], preferences[1], preferences[2], preferences[3]); }

    //stuff
    public List<Notification> addElements() { return this.getAll(); }
}