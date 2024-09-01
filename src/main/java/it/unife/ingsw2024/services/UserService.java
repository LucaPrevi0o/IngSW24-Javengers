package it.unife.ingsw2024.services;

import it.unife.ingsw2024.models.User;
import it.unife.ingsw2024.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/* Service class per interrogare il db  */
@Service
public class UserService {

    @Autowired private UserRepository userRepository;

    /* Metodo che effettua una select all sulla tabella Mysql */
    public List<User> getAll() {
        return userRepository.findAll();
    }

    public Optional<User> getUserById(int id) {
        return userRepository.findById(id);
    }

    /* Metodo che salva un record sulla tabella  */
    public void insert(User record){
        userRepository.save(record);
    }

    /* Metodo che inserisce dati e li recupera da un db H2 (in assenza di mysql) */
    public List<User> addElements() {

        return this.getAll();
    }
}