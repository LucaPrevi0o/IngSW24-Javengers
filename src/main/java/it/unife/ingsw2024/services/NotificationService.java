package it.unife.ingsw2024.services;

import it.unife.ingsw2024.models.Notification;
import it.unife.ingsw2024.repositories.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/* Service class per interrogare il db  */

@Service
public class NotificationService {

    @Autowired private NotificationRepository notificationRepository;

    /* Metodo che effettua una select all sulla tabella Mysql */
    public List<Notification> getAll() { return notificationRepository.findAll(); }

    //METODO che prende una notifica da id se esiste
    public Notification getById(int id){ return notificationRepository.findById(id).orElse(null); }

    public List<Notification> getALlByUserDSTId(int id) { return notificationRepository.findAllByUserDst(id); }

    /* Metodo che salva un record sulla tabella  */
    public void insert(Notification record){
        notificationRepository.save(record);
    }

    /* Metodo che inserisce dati e li recupera da un db H2 (in assenza di mysql) */
    public List<Notification> addElements() { return this.getAll(); }
}