// A system module containing protocol access constructs
// Module objects referenced with 'http:' in code
import ballerina/http;
import ballerina/io;
service hello on new http:Listener(9090) {

	resource function sayHello(http:Caller caller, http:Request request) returns error? {
		http:Response response = new;
		var params = request.getQueryParams();
		
		int number = check int.convert(<string>params.number);
	
		int count = 0;

		foreach var i in 3...(number) {
			var prime = true;
		        foreach var j in 2...(i-1) {
		 	       if(i % j == 0){
					prime = false;
					break; 	
				}
			}
			if(prime==true){
				count = count+1;
			}
		}
		
		
		response.setTextPayload(untaint io:sprintf("%s", count));
		check caller->respond(response);
    	}
}
