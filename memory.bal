// A system module containing protocol access constructs
// Module objects referenced with 'http:' in code
import ballerina/http;
import ballerina/io;
service hello on new http:Listener(9090) {

	resource function sayHello(http:Caller caller, http:Request request) returns error? {
		http:Response response = new;
		var params = request.getQueryParams();
		
		int number = check int.convert(<string>params.number);

		int[] array = [];
		foreach var i in 0...number {
		        array[i] = i*1000;
		}
				
		response.setTextPayload(untaint io:sprintf("%s", array.length()));
		check caller->respond(response);
    	}
}
