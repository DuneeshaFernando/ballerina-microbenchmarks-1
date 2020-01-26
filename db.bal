import ballerina/http;
import ballerina/io;
//import ballerina/sql;
import ballerinax/java.jdbc; //note java.jdbc
import ballerina/jsonutils;

jdbc:Client testDB = new({
        url: "jdbc:mysql://localhost:3306/db_example",
        username: "root", //"pasindu"
        password: "test@123", //"1234"
        poolOptions: { maximumPoolSize: 10000 },
        dbOptions: { useSSL: false }
    });

service microbenchmark on new http:Listener(9090) {

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
}