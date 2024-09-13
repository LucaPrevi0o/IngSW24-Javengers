package it.unife.ingsw2024.models.notification;

public enum NotificationType {

    MESSAGES("Messaggi"),
    FOLLOWERS("Follower"),
    EVENTS("Eventi"),
    PAYMENTS("Pagamenti");

    private final String description;

    NotificationType(String name) { this.description=name; }
    public String toString() { return this.description; }
}
