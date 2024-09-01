package it.unife.ingsw2024.repositories;

import it.unife.ingsw2024.models.Notification;
import it.unife.ingsw2024.models.User;
import org.springframework.data.jpa.repository.JpaRepository;

/* Classe che definisce il repository (database)  */
public interface UserRepository extends JpaRepository<User, Integer> {

}
