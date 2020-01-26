// A system module containing protocol access constructs
// Module objects referenced with 'http:' in code
import ballerina/http;
import ballerina/io;
import ballerina/lang.'int as ints;

service microbenchmark on new http:Listener(9090) {

	resource function file(http:Caller caller, http:Request request) returns @tainted error? {
		http:Response response = new;
		var params = request.getQueryParams();
		var filename = "./files/"+<string>params.get("file")[0];
		io:ReadableByteChannel readableFieldResult = check io:openReadableFile(<@untainted> filename);
		io:ReadableCharacterChannel sourceChannel = new(readableFieldResult, "UTF-8");
		int file_size=check ints:fromString(params.get("size")[0]);
		string fileText = check sourceChannel.read(<@untainted> file_size);	
		var close_result = sourceChannel.close();	
		response.setTextPayload(<@untainted> fileText);
		check caller->respond(response);
    	}
}
