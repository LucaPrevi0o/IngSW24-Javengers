package it.unife.ingsw2024.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Table(name="USER")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {

    @Id @Column(name="id")
    private int id; //id utente

    @Column(name="Username")
    private String username; //username utente
}
