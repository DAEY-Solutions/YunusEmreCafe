package Kunde;

import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;

@ApplicationScoped
public class KundeServices {

public List<Kunde> getAll(){
    return Kunde.listAll();
}


}
