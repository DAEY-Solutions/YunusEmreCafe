package Kunde;


import SchuldenObject.SchuldenObjekt;
import io.quarkus.hibernate.orm.panache.PanacheEntity;
import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "kunde")
public class Kunde extends PanacheEntity {
    public String vorname;
    public String nachname;
    @OneToMany
    public List<SchuldenObjekt> schuldenObjekte;
    public double saldo;
}