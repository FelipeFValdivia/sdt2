import math
import grpc
from concurrent import futures
import time
import random
# import the generated classes
import control_pb2
import control_pb2_grpc
import datetime

# import the original calculator.py
#import calculator


# create a class to define the server functions, derived from
# calculator_pb2_grpc.CalculatorServicer

class ControlServicer(control_pb2_grpc.ControlServicer):

    # calculator.square_root is exposed here
    # the request and response are of the data type
    # calculator_pb2.Number
	def GetLane(self, request, context):
		response = control_pb2.Lane()
		response.value = get_lane(request.value)
		return response

	def GetOutLane(self, request, context):
		response = control_pb2.Lane()
		response.value = get_out_lane(request.value)
		return response

	def SendAirplaneName(self, request, context):
		response = control_pb2.Lane()
		response.value = send_airplane_name(request.value)
		return response

	def SendDestination(self, request, context):
		response = control_pb2.Name()
		response.value = send_destination(request.value, request.destination)
		return response

	def CheckPassengerAndFuell(self, request, context):
		response = control_pb2.FuellDestination()
		response.name = check_passenger_and_fuell(request.name, request.fuell, request.passengers)
		return response

	def CheckRunway(self, request, context):
		response = control_pb2.Lane()
		response.value = check_runway(request.value)
		return response

	def GetOutRunway(self, request, context):
		response = control_pb2.Lane()
		response.value = get_out_runway(request.value)
		return response
	
	def GetPlanes(self, request, context):
		response = control_pb2.Plane()
		response.name = get_planes("var")
		return response

	def GetDeparturesPlanes(self, request, context):
		print("departures")
		print("departures")
		print("departures")
		print("departures")
		print("departures")
		response = control_pb2.Plane()
		response.name = get_departures_planes("var")
		return response


def get_lane(airplane_name):
	print("[Torre de control - " + name + "] Nuevo Avion en el Aeropuerto")
	print("[Torre de control - " + name + "] Asignando pista de aterrizaje...")
	current_lane = -1
	for i in range(0, landing_lane):
		if not bussy_landing_lanes[i]:
			current_lane = i
			break


	if current_lane > -1:
		bussy_landing_lanes[current_lane] = True
		arrives_planes[current_lane] = {}
		arrives_planes[current_lane] = {"name": str(airplane_name).encode("ascii"), "lane": current_lane + 1, "time": datetime.datetime.now().strftime("%H:%M:%S")}
		print("[Torre de control - " + name + "] La pista de aterrizaje asignada es la " + str(current_lane + 1))
	else:
		print("[Torre de control - " + name + "] Todas las pistas se encuentran ocupadas.")

	return current_lane + 1

def get_out_lane(n):
	print("[Torre de control - " + name + "] Pista " + str(int(n)) + " ha sido desocupada")
	bussy_landing_lanes[int(n) - 1] = False
	return 1

def send_airplane_name(airplane_name):
	print("[Torre de control - " + name + "] Avion " + airplane_name + " quiere despegar	" )
	planes_hash[str(airplane_name).encode("ascii")] = {}	
	return 0


def send_destination(airplane_name, destination):
	print("[Torre de control - " + name + "] Recibiendo el destindo del avion " + airplane_name)
	planes_hash[str(airplane_name).encode("ascii")]["destination"] = destination.encode("ascii")


	response_destination_ip = "Destino no encontrado"

	for destination_of_fly in destinys_identifiers:
		if str(airplane_name).encode("ascii") in destination_of_fly:
			response_destination_ip = str.split(destination_of_fly, " ")[-1]
	return response_destination_ip

def check_passenger_and_fuell(airplane_name, fuell, passengers):
	print("[Torre de control - " + name + "] Consultado restricciones de pasajeros y combustible.")
	
	return "1"

def check_runway(airplane_name):
	print("[Torre de control - " + name + "] Consultado restricciones de pasajeros y combustible.")
	current_runway = -1
	for i in range(0, runway):
		if not bussy_runways[i]:
			current_runway = i
			break

	if current_runway > -1:
		bussy_runways[current_runway] = True
		departures_planes[current_runway] = {"name": str(airplane_name).encode("ascii"), "destination": planes_hash[str(airplane_name).encode("ascii")]["destination"],"runway": current_runway + 1, "time": datetime.datetime.now().strftime("%H:%M:%S")}
		print("[Torre de control - " + name + "] La pista de despegue asignada es la " + str(current_runway + 1))
	else:
		print("[Torre de control - " + name + "] Todas las pistas se encuentran ocupadas.")
	current_runway += 1
	return current_runway

def get_out_runway(n):
	print("[Torre de control - " + name + "] Pista de despegue" + str(int(n)) + " ha sido desocupada")
	bussy_runways[int(n)] = False
	return 1


def get_planes(var):
	response_string = "Arrivals\r\nAvion     Destino     Pista   Hr\r\n"
	for idx, val in enumerate(arrives_planes):
		if bussy_landing_lanes[idx]:
			response_string = response_string + str(val["name"]) + "       " + str(val["lane"]) + " " + str(val["time"])
	return response_string

def get_departures_planes(var):
	response_string = "Departures\nAvion  Destino  Pista   Hr\n\n"

	for idx, val in enumerate(departures_planes):
		if bussy_runways[idx]:
			response_string = response_string + str(val["name"]) + " " + str(val["destination"]) + " " + str(val["runway"]) + " " + str(val["time"])
	return response_string

planes_hash = {}

arrives_planes = []
departures_planes = []

# create a gRPC server
server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))

# use the generated function `add_CalculatorServicer_to_server`
# to add the defined class to the server
control_pb2_grpc.add_ControlServicer_to_server(
        ControlServicer(), server)

# listen on port 50051
#print('Starting server. Listening on port 50051.')
server.add_insecure_port('[::]:50051')
server.start()


print("Bienvenido a la Torre de control")
print("[Torre de control] Nombre del Aeropuerto:")
name = raw_input("")

print("[Torre de control - " + name + "] Cantidad de pistas de aterrizaje:")
landing_lane = int(raw_input(""))


print("[Torre de control - " + name + "] Cantidad de pistas de despegue:")
runway = int(raw_input(""))

bussy_landing_lanes = []
for i in range(0, landing_lane):
	bussy_landing_lanes.append(False)
	arrives_planes.append({})
bussy_runways = []
for i in range(0, runway):
	bussy_runways.append(False)
	departures_planes.append({})

destinys_identifiers = []
airplaine_array = []

while True:
	raw_input("[Torre de control - " + name + "] Para agregar destino presione enter")
	print("[Torre de control - " + name + "] Ingrese nombre y direccion IP del destino:")
	destiny_identifier = raw_input("")

	destinys_identifiers.append(destiny_identifier)

	print("[Torre de control - Santiago] Destino agregado con exito")


try:
    while True:
        time.sleep(86400)
except KeyboardInterrupt:
    server.stop(0)

