package it.unife.ingsw2024.repositories;

import it.unife.ingsw2024.models.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

/* Classe che definisce il repository (database)  */
public interface NotificationRepository extends JpaRepository<Notification, Integer> {
    /*@Query("SELECT n " +
            "FROM Notification n " +
            "WHERE n.userDst = ?1 ")
    List<Notification> findAllByUserDst(User user);*/

    @Query(value = "SELECT n FROM Notification n WHERE n.UserDst = ?1")
    List<Notification> findAllByUserDst(int id);
}
