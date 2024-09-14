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
    @Autowired private UserService userService;
    @Autowired private SimpMessagingTemplate simpMessagingTemplate;

    //funzione di controllo per verificare se l'utente destinatario può ricevere la notifica
    private boolean isNotificationReceivable(Notification n) {

        var userPref=this.getUserPreferences(n.getUserDst().getId()); //lista preferenze notifiche utente loggato
        var blockedUsersList=this.userService.getBlockedUsersList(n.getUserDst().getId()); //lista utenti bloccati utente loggato
        return !blockedUsersList.contains(n.getUserSrc()) && ( //controllo per verificare che l'utente non sia bloccato
            n.getNotificationType()==NotificationType.MESSAGES && userPref.isMessages() || //controllo preferenze sulle categorie di notifiche
            n.getNotificationType()==NotificationType.FOLLOWERS && userPref.isFollowers() ||
            n.getNotificationType()==NotificationType.EVENTS && userPref.isEvents() ||
            n.getNotificationType()==NotificationType.PAYMENTS && userPref.isPayments());
    }

    //funzione di invio messaggio come notifica push
    public void sendNotification(User userSrc, User userDst, NotificationType notificationType, String notificationMessage) {

        var notification=new Notification();
        var now=LocalDateTime.now();

        var date=Date.valueOf(now.toLocalDate());
        var time=Time.valueOf(now.toLocalTime());

        //costruzione oggetto Notification attraverso i parametri
        notification.setUserSrc(userSrc);
        notification.setUserDst(userDst);
        notification.setNotificationType(notificationType);
        notification.setNotificationMsg(notificationMessage);
        notification.setNotificationDate(date);
        notification.setNotificationTime(time);

        if (isNotificationReceivable(notification)) {

            //aggiunta notifica al database, la funzione restituisce la notifica aggiornata con l'id
            var insertedNotification=notificationRepository.save(notification);

            //invio il messaggio a "/private/{userDstId}/messages" (la notifica viene serializzata in JSON automaticamente)
            simpMessagingTemplate.convertAndSend("/private/"+userDst.getId()+"/messages", insertedNotification);
        }
    }

    //lettura insieme di record dal database
    public List<Notification> getAll() { return notificationRepository.findAll(); }

    //lettura record da database con campo "id" specificato
    public Notification getById(int id) { return notificationRepository.findById(id).orElse(null); }

    //lettura insieme di record da database con campo "UserDST" specificato
    public List<Notification> getAllByUserDstId(int id) { return notificationRepository.findAllByUserDst(id); }

    @Transactional //inserimento nuovo record
    public void insert(Notification record) { notificationRepository.save(record); }

    @Transactional //inserimento lista record
    public void insertAll(List<Notification> recordSet) { notificationRepository.saveAll(recordSet); }

    @Transactional //cancellazione record notifiche visualizzate
    public void deleteAllRead(int id) { notificationRepository.deleteAllRead(id); }

    //lettura preferenze notifiche utente
    public NotificationPreferencesMapping getUserPreferences(int id) { return notificationRepository.findUserPreferences(id); }

    @Transactional //aggiornamento preferenze notifiche utente
    public void updatePreferences(int id, boolean[] preferences) { notificationRepository.updatePreferences(id, preferences[0], preferences[1], preferences[2], preferences[3]); }
}