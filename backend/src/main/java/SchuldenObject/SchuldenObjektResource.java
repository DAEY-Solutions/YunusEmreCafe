package SchuldenObject;

import Kunde.Kunde;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/SchuldenObjekt")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class SchuldenObjektResource {

    @Inject
    SchuldenObjektServices schuldenObjektServices;
    @Inject
    SchuldenObjektRepository schuldenObjektRepository;

    @POST
    @Transactional
    public Response create(SchuldenObjekt schuldenObjekt){
        schuldenObjekt.persist();
        if (schuldenObjektRepository.isPersistent(schuldenObjekt)) {
            return Response.status(Response.Status.CREATED).entity(schuldenObjekt).build();
        }
        return Response.serverError().build();
    }

    @PUT
    @Transactional
    public Response set_paid(SchuldenObjekt schuldenObjekt){
        SchuldenObjekt so = schuldenObjektRepository.findById(schuldenObjekt.id);
        so.bezahlt = true;
        schuldenObjektRepository.getEntityManager().merge(so);
        return Response.ok().build();
    }

}