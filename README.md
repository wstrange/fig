# Fig - Firebase Identity for Flutter using gRPC

Fig provides two packages:

* fig_auth - for Dart server code. Implements an authentication framework for your Dart gRPC services.
* fig_flutter - Provides client authentication to your gRPC dart server code

Both packages delegate _authentication_ to Firebase. These packages provide a framework
for integrating authentication into your gRPC services. 

Use this if:

* Your server is written in Dart.
* You want your Flutter client to interact with your Dart server using gRPC instead of http/json.

This code is lightly tested and POC quality. If there is further interest let's collaborate.

## How it works: The Readers Digest version

* The Flutter client authenticates to Firebase and obtains an OIDC token.
* The client calls the `Authenticate` gRPC method provided by `fig_auth`, passing along the OIDC token.
* The `fig_auth` package validates the OIDC token using PKI.
* If the token is valid, fig_auth creates a `Session` for the user, and returns an opaque session cookie
to the client in the response.
* The client provides the session cookie in subsequent calls using a gRPC `Authorization` header.
* The interceptor provided by `fig_auth` looks for a valid session cookie. If the cookie is valid, and 
 the session has not timed out, the call will be allowed to proceed to your gRPC method. If the
 session is not valid, or a cookie is not provided, a gRPC error will be returned to the client.
* You can mark some of your gRPC methods as being unauthenticated. The interceptor will not enforce
 the previous rules.

  
## Running the example

An example [service](fig_auth/example/bin/run.dart) and [Flutter client](fig_flutter/example/lib/main.dart) are 
provided as an example.

The easiest way to demo this is to use the provided envoy gRPC proxy and launch a Flutter web app.

To run the proxy and start the example service:

```bash
cd fig_auth/example
./run.sh
```

Once the server has started, launch the Flutter client in Chrome (from your IDE: run flutter_fig/example/lib/main.dart).

---
**NOTE**

If you are not familiar with gRPC, the use of envoy may be puzzling. gRPC uses http/2 which is
not natively supported by web browsers.  In order to use gRPC in a web app, you need to use
a flavour of gRPC (grpc-web) that can be sent over http/1.  The Envoy proxy
converts the gRPC web traffic over http/1 to "native" gRPC over http/2.

---



## fig_auth

fig_auth is the server framework used to integrate gRPC authentication with the rest of your 
gRPC services. The basic idea is that you "mixin" these gRPC calls with the rest of your services.

It consists of:

* Generated gRPC/protobuf methods to handle client authenticaition calls. 
* 