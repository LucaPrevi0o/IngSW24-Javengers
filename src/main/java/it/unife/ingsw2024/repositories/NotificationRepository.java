package it.unife.ingsw2024.repositories;

import it.unife.ingsw2024.models.Notification;
import it.unife.ingsw2024.models.NotificationPreferencesMapping;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

//notification DAO (list of allowed database operations, each one associated to a specific query)
public interface NotificationRepository extends JpaRepository<Notification, Integer> {

    @Query(value="SELECT n FROM Notification n WHERE n.userDst.id = ?1 order by n.notificationDate desc, n.notificationTime desc")
    List<Notification> findAllByUserDst(int id);

    @Query(value="SELECT n FROM Notification n order by n.notificationDate desc, n.notificationTime desc")
    List<Notification> findAll();

    @Modifying
    @Query(value="delete from NOTIFICATIONS where UserDST = ?1 and Viewed = 1", nativeQuery=true)
    void deleteAllRead(int userId);

    @Query(value="select npm from NotificationPreferencesMapping npm where npm.id = ?1")
    NotificationPreferencesMapping findUserPreferences(int userId);

    @Modifying
    @Query(value="update PREFERENCES set messages = ?2, followers = ?3, events = ?4, payments = ?5 where id = ?1", nativeQuery=true)
    void updatePreferences(int userId, boolean messages, boolean followers, boolean events, boolean payments);
}