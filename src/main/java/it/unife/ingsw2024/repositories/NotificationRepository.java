package it.unife.ingsw2024.repositories;

import it.unife.ingsw2024.models.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

//notification DAO (list of allowed database operations, each one associated to a specific query)
public interface NotificationRepository extends JpaRepository<Notification, Integer> {

    @Query(value="SELECT n FROM Notification n WHERE n.UserDst.id = ?1")
    List<Notification> findAllByUserDst(int id);
}