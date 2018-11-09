const grpc = require('grpc');

const protoPath = require('path').join(__dirname, '../..', 'proto');
const proto = grpc.load({root: protoPath, file: 'control.proto' });

//Create a new client instance that binds to the IP and port of the grpc server.

var stdin = process.openStdin();

console.log("[Pantalla de informacion] Ingrese la IP del aeropuerto que desea escuchar:")

stdin.addListener("data", function(d) {
    const client = new proto.Control(d.toString().trim() + ":50051", grpc.credentials.createInsecure());
    // note:  d is an object, and when converted to a string it will
    // end with a linefeed.  so we (rather crudely) account for that  
    // with toString() and then trim() 
    client.GetPlanes(1, (error, response) => {
      if (!error) {
        console.log(response["name"]);
      } else {
        console.log("Error:", error.message);
      }

    });
    client.GetDeparturesPlanes(1, (error, response) => {
      if (!error) {
        console.log(response["name"]);
      } else {
        console.log("Error:", error.message);
      }
    });
    

    console.log("[Pantalla de informacion] Ingrese la IP del aeropuerto que desea escuchar:")
    
});
