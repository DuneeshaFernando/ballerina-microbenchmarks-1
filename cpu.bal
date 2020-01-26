// A system module containing protocol access constructs
// Module objects referenced with 'http:' in code
import ballerina/http;
import ballerina/io;
import ballerina/lang.'int as ints;

service microbenchmark on new http:Listener(9090) {

	resource function cpu(http:Caller caller, http:Request request) returns error? {
		http:Response response = new;
		var params = request.getQueryParams();

		//Initial code according to earlier syntax
		//int number = ints:fromString(params.number);

		//Working code according to new syntax
		//var number_str_array=params.get("number");
		//int number=check ints:fromString(number_str_array[0]);

		//Combined code - works according to new syntax
		int number=check ints:fromString(params.get("number")[0]);
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
		
		
		response.setTextPayload(<@untainted> io:sprintf("%s", count));
		check caller->respond(response);
    	}
}
