import ballerina/http;
import ballerina/io;
import ballerina/sql;
import ballerinax/jdbc;


jdbc:Client testDB = new({
        url: "jdbc:mysql://localhost:3306/db_example",
        username: "pasindu",
        password: "1234",
        poolOptions: { maximumPoolSize: 10000 },
        dbOptions: { useSSL: false }
    });

service hello on new http:Listener(9090) {

	resource function sayHello(http:Caller caller, http:Request request) returns error? {
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
}
