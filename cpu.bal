// A system module containing protocol access constructs
// Module objects referenced with 'http:' in code
import ballerina/http;
import ballerina/io;
service hello on new http:Listener(9090) {

	resource function sayHello(http:Caller caller, http:Request request) returns error? {
		http:Response response = new;
		var params = request.getQueryParams();
		
		int number = check int.convert(<string>params.number);
	
		var answer = true;
		foreach var i in 2...(number-1) {
		        if(number % i == 0){
				answer = false;
				break; 	
			}
		}
		
		response.setTextPayload(untaint io:sprintf("%s", answer));
		check caller->respond(response);
    	}
}
