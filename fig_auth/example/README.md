# A sample server application using fig

Provides a simple gRPC service that has two hello methods. One
is authenticated (will enforce authentication) and one
is unauthenticated. 

This is intended to be used with the sample flutter application which
will authenticate using Firebase, and then allow the user to invoke the hello 
methods. 

## Generating the proto stubs

protoc --dart_out=grpc:lib/src/generated fig_serv.proto

## Running:

`dart run bin/run.dart`

You should see the server start on port 50051.


