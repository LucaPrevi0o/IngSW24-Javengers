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

    @Id @Column(name = "id")
    private int id;

    @Column(name = "messages", columnDefinition = "TINYINT")
    private boolean messages;

    @Column(name = "followers", columnDefinition = "TINYINT")
    private boolean followers;

    @Column(name = "events", columnDefinition = "TINYINT")
    private boolean events;

    @Column(name = "payments", columnDefinition = "TINYINT")
    private boolean payments;
}