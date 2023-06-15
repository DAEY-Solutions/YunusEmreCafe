package SchuldenObject;

import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class SchuldenObjektRepository implements PanacheRepository<SchuldenObjekt> {
}
