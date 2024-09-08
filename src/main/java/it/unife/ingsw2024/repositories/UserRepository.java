package it.unife.ingsw2024.repositories;

import it.unife.ingsw2024.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import java.util.List;
import java.util.Optional;

//user DAO (list of allowed database operations, each one associated to a specific query)
public interface UserRepository extends JpaRepository<User, Integer> {

    @Query("SELECT u FROM User u WHERE u.id = ?1 ")
    Optional<User> findById(Integer userId);

    @Query("select u from User u where u.id in (select fm.followerId from FollowerMapping fm where fm.followedId = ?1)")
    List<User> findFollowersById(int id);

    @Query("select u from User u where u.id in (select fm.followedId from FollowerMapping fm where fm.followerId = ?1)")
    List<User> findFollowedById(int id);

    @Query("select u from User u where u.id in (select bl.blockedUserId from BlockedUserMapping bl where bl.blockerUserId = ?1)")
    List<User> findBlockedById(int id);

    @Modifying
    @Query(value="insert into FOLLOWERS (follower, followed) values (?1, ?2)", nativeQuery=true)
    void follow(int followerId, int followedId);

    @Modifying
    @Query(value="delete from FOLLOWERS where follower = ?1 and followed = ?2", nativeQuery=true)
    void unfollow(int followerId, int followedId);

    @Modifying
    @Query(value="insert into BLOCKED_USERS (BlockedUser, BlockerUser) value (?1, ?2)", nativeQuery=true)
    void block(int blockedUserId, int userId);
}