package Kunde;

import Produkt.Produkt;
import SchuldenObject.SchuldenObjekt;
import SchuldenObject.SchuldenObjektRepository;
import SchuldenObject.SchuldenObjektResource;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.jboss.logging.annotations.Param;

@Path("/Kunde")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class KundeResource {

    @Inject
    KundeServices kundeServices;
    @Inject
    KundeRepository kundeRepository;
    @Inject
    SchuldenObjektRepository schuldenObjektRepository;

    @POST
    @Transactional
    public Response create(Kunde kunde) {
        kunde.persist();
        if (kundeRepository.isPersistent(kunde)) {
            return Response.status(Response.Status.CREATED).entity(kunde).build();
        }
        return Response.serverError().build();
    }

    @POST
    @Path("{id}")
    @Transactional
    public Response addSchuldenObjekt(Long id, SchuldenObjekt schuldenObjekt){
        schuldenObjekt.persist();
        Kunde kunde = kundeRepository.findById(id);
        kunde.schuldenObjekte.add(schuldenObjekt);
        kunde.persistAndFlush();
        if (kundeRepository.isPersistent(kunde)) {
            return Response.status(Response.Status.CREATED).entity(schuldenObjekt).build();
        }
        return Response.serverError().build();
    }

   @GET
   public Response getAllKunden(){
        return Response.ok(kundeRepository.listAll()).build();
   }
}