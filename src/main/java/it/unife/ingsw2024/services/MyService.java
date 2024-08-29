package it.unife.ingsw2024.services;

import it.unife.ingsw2024.models.Notification;
import it.unife.ingsw2024.repositories.MyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/* Service class per interrogare il db  */
@Service
public class MyService {

    @Autowired private MyRepository myRepository;

    /* Metodo che effettua una select all sulla tabella Mysql */
    public List<Notification> getAll() {
        return myRepository.findAll();
    }

    /* Metodo che salva un record sulla tabella  */
    public void insert(Notification record){
        myRepository.save(record);
    }

    /* Metodo che inserisce dati e li recupera da un db H2 (in assenza di mysql) */
    public List<Notification> addElements() {

        return this.getAll();
    }
}