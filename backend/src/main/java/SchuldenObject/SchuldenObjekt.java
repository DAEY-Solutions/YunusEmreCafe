package SchuldenObject;


import Kunde.Kunde;
import Produkt.Produkt;
import io.quarkus.hibernate.orm.panache.PanacheEntity;
import jakarta.persistence.Entity;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.time.LocalDateTime;

@Entity
@Table(name = "schulden_objekte")
public class SchuldenObjekt extends PanacheEntity {
    @ManyToOne
    public Produkt produkt;
    public Boolean bezahlt;
    public String whenn;

}