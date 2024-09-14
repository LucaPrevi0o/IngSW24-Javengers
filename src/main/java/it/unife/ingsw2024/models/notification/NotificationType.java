package it.unife.ingsw2024.models.notification;

import com.fasterxml.jackson.annotation.JsonValue;

public enum NotificationType {

    MESSAGES("Messaggi"),
    FOLLOWERS("Follower"),
    EVENTS("Eventi"),
    PAYMENTS("Pagamenti");

    private final String description;

    NotificationType(String name) { this.description=name; }

    @JsonValue
    public String toString() { return this.description; }
}
