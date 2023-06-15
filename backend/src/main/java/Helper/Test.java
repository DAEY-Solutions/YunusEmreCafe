package Helper;

import org.jboss.resteasy.annotations.providers.multipart.MultipartForm;
import org.jboss.resteasy.plugins.providers.multipart.MultipartFormDataInput;
import jakarta.inject.Inject;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/upload")
public class Test {

    @Inject
    Fileuploadservice fileUploadService;

    @POST
    @Path("/files")
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    @Produces(MediaType.TEXT_PLAIN)
    public Response fileUpload(@MultipartForm MultipartFormDataInput
                                       input) {
        System.out.println("HALLO");
        return Response.ok().
                entity(fileUploadService.uploadFile(input)).build();
    }
}