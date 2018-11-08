require 'grpc'

$:.unshift File.dirname(__FILE__)
require 'control_services_pb'


class Plane
  def initialize(company, number,weight,tank,tower)
    @company = company
    @number = number
    @weight = weight
    @tank = tank
    @tower = tower
  end
  def set_weight(weight)
    @weight = weight
  end
  def set_tank(tank)
    @tank = tank
  end
  def set_tower(tower)
    @tower = tower
  end
  def get_company
    @company
  end
  def get_number
    @number
  end
  def get_weight
    @weight
  end
  def get_tank
    @tank
  end
  def get_tower
    @tower
  end
end

puts "Bienvenido al vuelo\n[Avion] Nombre de la Aerolinea y numero de Avion:"
a = gets.chomp
linea = a.split(" ")[0]
a = a.split(" ")[1]
puts "[Avion - " + a + "] Peso maximo de carga [Kg]:" 
b = gets.chomp
puts "[Avion - " + a + "] Capacidad del tanque de combustible [L]:" 
c = gets.chomp
puts "[Avion - " + a + "] Torre de Control Inicial:" 
d = gets.chomp

plane = Plane.new(linea, a, b, c, d)



puts "[Avion - " + a + "]: Esperando pista aterrizaje..."

response = -1

stub = Control::Stub.new('localhost:50051', :this_channel_is_insecure)
response = stub.get_lane(Lane.new(value: 45))

while response.value.to_i < 0
  puts "Sin pista disponible, espera en la altura #{-response.value.to_i} km"
  stub = Control::Stub.new('localhost:50051', :this_channel_is_insecure)
  response = stub.get_lane(Lane.new(value: 45))
  response.value.to_i
end
puts "[Avion - " + a + "]: Aterrizando en la pista " + response.value.to_i.to_s + " ..." 



puts "[Avion - " + a + "]: Presione enter para despegar"
gets.chomp

stub = Control::Stub.new('localhost:50051', :this_channel_is_insecure)
stub.send_airplane_name(Name.new(value: a))


puts "[Avion - " + a + "]: Ingrese destino:"
destiny = gets.chomp
stub = Control::Stub.new('localhost:50051', :this_channel_is_insecure)
new_tower = stub.send_destination(Name.new(value: a, destination: destiny))
plane.set_tower(new_tower.value.to_s)
puts "El Destino es " + plane.get_tower
puts "[Avion - " + a + "]: Pasando por el Gate..."

stub = Control::Stub.new('localhost:50051', :this_channel_is_insecure)

checked = stub.check_passenger_and_fuell(FuellDestination.new(name: a, fuell: plane.get_tank.to_i, passengers: plane.get_weight.to_i))
if checked.value.to_i == 1
  puts "[Avion - " + a + "]: Pidiendo instrucciones para despegar..."
else
  puts "[Avion - " + a + "]: Ha recargado combustible y reducido peso"
end

stub = Control::Stub.new('localhost:50051', :this_channel_is_insecure)
runway_check = stub.check_runway(Name.new(value: a, destination: plane.get_tower))

while runway_check.value.to_i < 0
  stub = Control::Stub.new('localhost:50051', :this_channel_is_insecure)
  runway_check = stub.check_runway(Name.new(value: a, destination: plane.get_tower))
  puts "[Avion - " + a + "]: Todas las pistas estan ocupadas, el avion predecesor es BRC3536..."
end

stub = Control::Stub.new('localhost:50051', :this_channel_is_insecure)
response = stub.get_out_lane(Lane.new(value: response.value.to_i))

while response.value.to_i < 1
  stub = Control::Stub.new('localhost:50051', :this_channel_is_insecure)
  response = stub.get_out_lane(Lane.new(value: 45))
end
puts "[Avion - " + a + "]: Pista " + runway_check.value.to_i.to_s + " asignada y altura de  km."

#TODO avion predecesorTodas las pistas est´an ocupadas, el avi´on predecesor es BRC3536...

#TODO pista y altura
puts "[Avion - " + a + "]: Despegando..."

stub = Control::Stub.new('localhost:50051', :this_channel_is_insecure)
response = stub.get_out_runway(Lane.new(value: runway_check.value.to_i))
