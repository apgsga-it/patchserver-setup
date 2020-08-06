@GrabResolver(name='restlet', root='http://maven.restlet.org/')
@Grab(group='org.restlet', module='org.restlet', version='1.1.6')
import com.apgsga.patch.service.client.PatchCli
System.exit(PatchCli.create().process(args).returnCode)