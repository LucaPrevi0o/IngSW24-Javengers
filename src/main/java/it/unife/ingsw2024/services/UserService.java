package it.unife.ingsw2024.services;

import it.unife.ingsw2024.models.User;
import it.unife.ingsw2024.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

//user service
@Service public class UserService {

    @Autowired private UserRepository userRepository;

    //lettura record da database con campo "id" specificato
    public User getUserById(int id) { return userRepository.findById(id).orElse(null); }

    //lettura lista follower utente
    public List<User> getFollowerList(int id) { return userRepository.findFollowersById(id); }

    //lettura lista profili seguiti utente
    public List<User> getFollowedList(int id) { return userRepository.findFollowedById(id); }

    //lettura lista profili bloccati utente
    public List<User> getBlockedUsersList(int id) { return userRepository.findBlockedById(id); }

    @Transactional //operazione di following
    public void follow(int followerId, int followedId) { this.userRepository.follow(followerId, followedId); }

    @Transactional //rimozione following
    public void unfollow(int followerId, int followedId) { this.userRepository.unfollow(followerId, followedId); }

    @Transactional //blocco profilo utente
    public void block(int blockedId, int blockerId) { this.userRepository.block(blockedId, blockerId); }

    @Transactional //rimozione blocco profilo utente
    public void unblock(int blockedId, int blockerId) { this.userRepository.unblock(blockedId, blockerId); }
}