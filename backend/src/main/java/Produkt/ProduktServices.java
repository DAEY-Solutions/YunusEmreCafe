package Produkt;

import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;

@ApplicationScoped
public class ProduktServices {

public List<Produkt> getAll(){
    return Produkt.listAll();
}


}
