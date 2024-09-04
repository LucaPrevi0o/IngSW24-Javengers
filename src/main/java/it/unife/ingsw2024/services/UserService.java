package it.unife.ingsw2024.services;

import it.unife.ingsw2024.models.User;
import it.unife.ingsw2024.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

//user service
@Service public class UserService {

    @Autowired private UserRepository userRepository;

    //return every user account registered in database
    public List<User> getAll() { return userRepository.findAll(); }

    //return a user account filtering data by user id
    public User getUserById(int id) { return userRepository.findById(id).orElse(null); }

    //register a new user account
    public void insert(User record) { userRepository.save(record); }

    public List<User> getFollowerList(int id) { return userRepository.findFollowersById(id); }

    public List<User> getFollowedList(int id) { return userRepository.findFollowedById(id); }
}