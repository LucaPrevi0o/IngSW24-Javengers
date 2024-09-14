package it.unife.ingsw2024.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name="FOLLOWERS")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class FollowerMapping {

    @Id @Column(name="id")
    private int id;

    @Column(name="Follower")
    private int followerId; //id utente follower

    @Column(name="Followed")
    private int followedId; //id utente seguito
}