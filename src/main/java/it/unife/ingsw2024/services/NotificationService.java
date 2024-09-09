package it.unife.ingsw2024.services;

import it.unife.ingsw2024.models.Notification;
import it.unife.ingsw2024.models.NotificationPreferencesMapping;
import it.unife.ingsw2024.repositories.NotificationRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

//notification service
@Service public class NotificationService {

    @Autowired private NotificationRepository notificationRepository;

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