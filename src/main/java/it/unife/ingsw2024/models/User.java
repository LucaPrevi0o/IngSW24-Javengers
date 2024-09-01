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

    @Column(name="id") @Id @GeneratedValue(strategy=GenerationType.IDENTITY) private int id; //user unique id (auto-incremented value)
    @Column(name="Username") private String username; //username

}
