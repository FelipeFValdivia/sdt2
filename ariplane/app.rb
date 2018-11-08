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
response = 0

stub = Control::Stub.new('192.168.43.61:50051', :this_channel_is_insecure)
response = stub.get_lane(Lane.new(value: 45))
response.value.to_i

while response.value.to_i < 1
  puts "Sin pista disponible, espera en la altura #{-response.value} km"
  stub = Control::Stub.new('192.168.43.61:50051', :this_channel_is_insecure)
  response = stub.get_lane(Lane.new(value: 45))
  response.value.to_i
end
puts "[Avion - " + a + "]: Aterrizando en la pista " + response.value.to_i.to_s + " ..." 



puts "[Avion - " + a + "]: Presione enter para despegar"
gets.chomp

stub = Control::Stub.new('192.168.43.61:50051', :this_channel_is_insecure)
stub.send_airplane_name(Name.new(value: a))


puts "[Avion - " + a + "]: Ingrese destino:"
destiny = gets.chomp
puts "[Avion - " + a + "]: Pasando por el Gate..."

puts "[Avion - " + a + "]: Pidiendo instrucciones para despegar..."
stub = Control::Stub.new('192.168.43.61:50051', :this_channel_is_insecure)
response = stub.get_out_lane(Lane.new(value: response.value.to_i))
response.value.to_i

while response.value.to_i < 1
  stub = Control::Stub.new('192.168.43.61:50051', :this_channel_is_insecure)
  response = stub.get_out_lane(Lane.new(value: 45))
  response.value.to_i
end

puts "[Avion - " + a + "]: Todas las pistas estan ocupadas, el avion predecesor es BRC3536..."


puts "[Avion - " + a + "]: Pista " + response.value.to_i.to_s + " asignada y altura de  km."
#TODO avion predecesorTodas las pistas est´an ocupadas, el avi´on predecesor es BRC3536...

#TODO pista y altura
puts "[Avion - " + a + "]: Despegando..."
