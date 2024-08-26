package it.unife.ingsw2024.repositories;

import it.unife.ingsw2024.models.MyTable;
import org.springframework.data.jpa.repository.JpaRepository;
/* Classe che definisce il repository (database)  */
public interface MyRepository extends JpaRepository<MyTable, Long> {

}
