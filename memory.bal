// A system module containing protocol access constructs
// Module objects referenced with 'http:' in code
import ballerina/http;
import ballerina/io;
import ballerina/lang.'int as ints;
service microbenchmark on new http:Listener(9090) {

	resource function memory(http:Caller caller, http:Request request) returns error? {
		http:Response response = new;
		var params = request.getQueryParams();
		
		int number = check ints:fromString(params.get("number")[0]);

		int[] array = [];
		foreach var i in 0...number {
		        array[i] = i*1000;
		}
				
		response.setTextPayload(<@untainted> io:sprintf("%s", array.length()));
		check caller->respond(response);
    	}
}
