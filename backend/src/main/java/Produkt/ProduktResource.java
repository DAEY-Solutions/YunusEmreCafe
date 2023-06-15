package Produkt;

import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/Produkt")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ProduktResource {

    @Inject
    ProduktServices produktServices;
    @Inject
    ProduktRepository produktRepository;

    @POST
    @Transactional
    public Response create(Produkt produkt){
        produkt.persist();
        if (produktRepository.isPersistent(produkt)) {
            return Response.status(Response.Status.CREATED).entity(produkt).build();
        }
        return Response.serverError().build();
    }

    @GET
    public Response getAllKunden(){
        return Response.ok(produktRepository.listAll()).build();
    }

}