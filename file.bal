// A system module containing protocol access constructs
// Module objects referenced with 'http:' in code
import ballerina/http;
import ballerina/io;

service microbenchmark on new http:Listener(9090) {

	resource function file(http:Caller caller, http:Request request) returns error? {
		http:Response response = new;
		var params = request.getQueryParams();
		var filename = "/home/pasindu/Project/WSO2/Server-Architectures/file_server/"+<string>params.file;
		io:ReadableCharacterChannel sourceChannel = new(io:openReadableFile(untaint filename), "UTF-8");
		int file_size = check int.convert(<string>params.file);
		string fileText = check sourceChannel.read(untaint file_size);		
		response.setTextPayload(untaint fileText);
		check caller->respond(response);
    	}
}
