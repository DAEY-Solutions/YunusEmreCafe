package Produkt;


import io.quarkus.hibernate.orm.panache.PanacheEntity;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "products")
public class Produkt extends PanacheEntity {
    public String name;
    public double preis;
    public int menge;
}