# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: control.proto for package ''

require 'grpc'
require 'control_pb'

module Control
  class Service

    include GRPC::GenericService

    self.marshal_class_method = :encode
    self.unmarshal_class_method = :decode
    self.service_name = 'Control'

    rpc :GetLane, Name, Lane
    rpc :GetOutLane, Lane, Lane
    rpc :SendAirplaneName, Name, Lane
    rpc :SendDestination, Name, Name
    rpc :CheckPassengerAndFuell, FuellDestination, Name
    rpc :CheckRunway, Name, Lane
    rpc :GetOutRunway, Lane, Lane
    rpc :GetPlanes, Lane, Plane
    rpc :GetDeparturesPlanes, Lane, Plane
  end

  Stub = Service.rpc_stub_class
end
