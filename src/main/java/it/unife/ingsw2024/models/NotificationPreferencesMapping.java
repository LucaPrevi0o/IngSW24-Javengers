package it.unife.ingsw2024.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name="PREFERENCES")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class NotificationPreferencesMapping {

    @Id @Column(name="id")
    private int id; //id utente

    @Column(name="messages", columnDefinition="TINYINT")
    private boolean messages; //preferenza notifiche messaggi

    @Column(name="followers", columnDefinition="TINYINT")
    private boolean followers; //preferenza notifiche follower

    @Column(name="events", columnDefinition="TINYINT")
    private boolean events; //preferenza notifiche eventi

    @Column(name="payments", columnDefinition="TINYINT")
    private boolean payments; //preferenza notifiche pagamenti

    //restituzione oggetto come array di valori boolean
    public boolean[] asList() { return new boolean[]{messages, followers, events, payments}; }
}