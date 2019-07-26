import ballerina/http;
import ballerina/io;
import ballerina/sql;
import ballerinax/jdbc;

jdbc:Client testDB = new({
        url: "jdbc:mysql://localhost:3306/db_example",
        username: "pasindu",
        password: "1234",
        poolOptions: { maximumPoolSize: 100000},
        dbOptions: { useSSL: false }
    });


service microbenchmark on new http:Listener(9090) {

	resource function cpu(http:Caller caller, http:Request request) returns error? {
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

	resource function db(http:Caller caller, http:Request request) returns error? {
		http:Response response = new;
		var params = request.getQueryParams();
		var id = <string>params.id;
		var query = "SELECT * FROM emp where id = "+id;
		var selectRet = testDB->select(untaint query, ());

		if (selectRet is table<record {}>) {
        		var jsonConversionRet = json.convert(selectRet);
        		if (jsonConversionRet is json) {
				response.setTextPayload(untaint io:sprintf("%s", jsonConversionRet));
				check caller->respond(response);
        		}
    		}
		
    	}

	resource function file(http:Caller caller, http:Request request) returns error? {
		http:Response response = new;
		var params = request.getQueryParams();
		var filename = "/home/pasindu/Project/WSO2/Server-Architectures/file_server/"+<string>params.file;
		io:ReadableCharacterChannel sourceChannel = new(io:openReadableFile(untaint filename), "UTF-8");
		int file_size = check int.convert(<string>params.file);
		string fileText = check sourceChannel.read(untaint file_size);	
		var close_result = sourceChannel.close();	
		response.setTextPayload(untaint fileText);
		check caller->respond(response);
    	}

	resource function io(http:Caller caller, http:Request request) returns error? {
		http:Response response = new;
		var params = request.getQueryParams();
		var message = <string>params.message;
		response.setTextPayload(untaint message);
		check caller->respond(response);
    	}

	resource function memory(http:Caller caller, http:Request request) returns error? {
		http:Response response = new;
		var params = request.getQueryParams();
		int number = check int.convert(<string>params.number);
		int[] array = [];
		foreach var i in 0...number {
		        array[i] = i*1000;
		}
		foreach var i in 0...number {
		        array[i] = array[i]*10;
		}		
		response.setTextPayload(untaint io:sprintf("%s", array.length()));
		check caller->respond(response);
    	}
}
