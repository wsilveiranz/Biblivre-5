package biblivre.core.translations.webservice;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import biblivre.core.translations.Translations;

@Path("translations/{schema}/{language}/{key}")
public class TranslationsResource {

	@GET
    @Produces(MediaType.APPLICATION_JSON)
    public String getTranslation(@PathParam("schema") String schema,
    			@PathParam("language") String language,
    			@PathParam("key") String key) {
        return Translations.get(schema, language).getText(key);
    }
	
}