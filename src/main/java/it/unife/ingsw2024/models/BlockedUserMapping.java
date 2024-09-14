package it.unife.ingsw2024.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name="BLOCKED_USERS")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class BlockedUserMapping {

    @Id @Column(name="id")
    private int id;

    @Column(name="BlockedUser")
    private int blockedUserId; //id utente bloccante

    @Column(name="BlockerUser")
    private int blockerUserId; //id utente bloccato
}