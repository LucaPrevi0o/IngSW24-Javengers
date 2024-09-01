package it.unife.ingsw2024.services;

import it.unife.ingsw2024.models.Notification;
import it.unife.ingsw2024.models.User;
import it.unife.ingsw2024.repositories.NotificationRepository;
import it.unife.ingsw2024.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

/* Service class per interrogare il db  */
@Service
public class NotificationService {

    @Autowired private NotificationRepository notificationRepository;
    /*@Autowired private UserRepository userRepository;*/

    /* Metodo che effettua una select all sulla tabella Mysql */
    public List<Notification> getAll() {
        return notificationRepository.findAll();
    }

    /*public List<Notification> getAllByUserId(int userId) {
        User user = userRepository.findById(userId).orElse(null);
        return notificationRepository.findAllByUserDst(user);

    }*/

    /* Metodo che salva un record sulla tabella  */
    public void insert(Notification record){
        notificationRepository.save(record);
    }

    /* Metodo che inserisce dati e li recupera da un db H2 (in assenza di mysql) */
    public List<Notification> addElements() {

        return this.getAll();
    }
}