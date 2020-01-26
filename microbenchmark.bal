import ballerina/http;
import ballerina/io;
import ballerina/lang.'int as ints;
//import ballerina/sql;
import ballerinax/java.jdbc; //note java.jdbc
import ballerina/jsonutils;

jdbc:Client testDB = new({
        url: "jdbc:mysql://localhost:3306/db_example",
        username: "root", //"pasindu"
        password: "test@123", //"1234"
        poolOptions: { maximumPoolSize: 100000},
        dbOptions: { useSSL: false }
    });


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

	resource function db(http:Caller caller, http:Request request) returns error? {
		http:Response response = new;
		var params = request.getQueryParams();
		var id = <string>params.get("id")[0];//<string>params.id
		var query = "SELECT * FROM emp where id = "+id;
		var selectRet = testDB->select(<@untainted> query, ());

		if (selectRet is table<record {}>) {
        		//var jsonConversionRet = json.convert(selectRet);
				json jsonConversionRet = jsonutils:fromTable(selectRet);
        		//io:println("JSON: ", jsonConversionRet.toJsonString());
        		//if (jsonConversionRet is json) {
				response.setTextPayload(<@untainted> io:sprintf("%s", jsonConversionRet));
				check caller->respond(response);
        		//}
    		}
    	}

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

	resource function io(http:Caller caller, http:Request request) returns error? {
		http:Response response = new;
		var params = request.getQueryParams();
		var message = <string>params.get("message")[0];
		response.setTextPayload(<@untainted> message);
		check caller->respond(response);
    	}

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
