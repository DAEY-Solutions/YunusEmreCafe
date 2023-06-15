package SchuldenObject;

import jakarta.enterprise.context.ApplicationScoped;

import java.util.List;

@ApplicationScoped
public class SchuldenObjektServices {

public List<SchuldenObjekt> getAll(){
    return SchuldenObjekt.listAll();
}


}
