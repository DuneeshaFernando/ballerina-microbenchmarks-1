// A system module containing protocol access constructs
// Module objects referenced with 'http:' in code
import ballerina/http;

service microbenchmark on new http:Listener(9090) {

	resource function io(http:Caller caller, http:Request request) returns error? {
		http:Response response = new;
		var params = request.getQueryParams();
		var message = <string>params.get("message")[0];
		response.setTextPayload(<@untainted> message);
		check caller->respond(response);
    	}
}
