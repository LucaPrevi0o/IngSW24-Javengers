package it.unife.ingsw2024.repositories;

import it.unife.ingsw2024.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

/* Classe che definisce il repository (database)  */
public interface UserRepository extends JpaRepository<User, Integer> {

    @Query("SELECT u FROM User u WHERE u.id = ?1 ")
    Optional<User> findById(Integer userId);
}