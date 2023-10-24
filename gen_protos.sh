#!/usr/bin/env bash
# Script to generate all the required protobuf implementation files
# Note rather than create inter-package dependencies on the
# protobuf project, we copy the generated files where required.


# Generate the fig_auth

(cd fig_proto && protoc --dart_out=grpc:lib/src/generated fig.proto)

# Generate the example protos
(cd fig_auth/example &&  protoc --dart_out=grpc:lib/src/generated example.proto)

# Copy the proto files to the required locations.

mkdir -p fig_flutter/lib/src/generated
cp -r fig_proto/lib/src/generated/* fig_flutter/lib/src/generated

mkdir -p fig_auth/lib/src/generated
cp -r fig_proto/lib/src/generated/*  fig_auth/lib/src/generated

# Copy the examples
cp -r fig_auth/example/lib/src/generated/* fig_flutter/example/lib/src/generated

