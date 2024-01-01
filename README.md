# Fig - Firebase Identity for Flutter using gRPC

Fig provides two packages:

* fig_auth - for Dart server code. Implements an authentication framework for your Dart gRPC services.
* fig_flutter - Provides client authentication to your Dart gRPC server code

Both packages delegate _authentication_ to Firebase. These packages provide a framework
for integrating authentication and session managment into your gRPC services. 

Use this if:

* You want to write your server in Dart.
* You want your Flutter client to interact with your Dart server using gRPC instead of http/json.
* You need basic session management.

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
provided.

The easiest way to demo this is to use the provided [script](fig_auth/example/run.sh) to launch the gRPC service and the envoy gRPC proxy:

```bash
cd fig_auth/example
./run.sh
```

Once the server has started, launch the Flutter client in Chrome (from your IDE: run flutter_fig/example/lib/main.dart).

You can login using `demo@test.com` with `Passw0rd`, or use Google Sign in.

---
**NOTE**

gRPC uses http/2 which is
not natively supported by web browsers.  In order to use gRPC in a web app, you need to use
a flavour of gRPC (grpc-web) that can be sent over http/1.  The Envoy proxy
converts this http/1 gRPC web traffic "native" gRPC over http/2.

If your clients are native (Desktop or Mobile) do NOT go through envoy. You want to go
directly to your gGRPC service.

---


## fig_auth

fig_auth is the server framework used to integrate gRPC authentication with the rest of your 
gRPC services. The basic idea is that you "mixin" these gRPC services with your own.

It consists of:

* Generated gRPC/protobuf methods to handle client authentication calls. 
* A service interceptor that will check for a valid session before forwarding the call to your
 services.
* A session manager to manage session lifetimes and session persistence.

The AuthService is initialized like this:

```dart
// AuthService is the required Fig Authentication service.
  final authSvc = AuthService(
      firebaseProjectId: firebaseId,
      sessionManager: sessionManager,
      // A list of grpc methods that will NOT be authenticated.
      unauthenticatedMethodNames: ['hello_no_auth',]);
```


Provide your firebase project id, and a list of gRPC method names that you do not want to enforce
authentication on (all other methods will be intercepted).

To create the Server:

```dart
 final server = Server.create(
    services: [authSvc, svc],
    // you MUST include the authInterceptor
    interceptors: [loggingInterceptor, authSvc.authInterceptor],
    codecRegistry: CodecRegistry(codecs: const [GzipCodec(),
      // To support grpc web, remove IdentityCode()
      // Per https://github.com/grpc/grpc-dart/issues/506#issuecomment-882058839
      // IdentityCodec()
    ]),

```
`svc` above is a handle to your own custom gRPC services.  The `authSvc.authInterceptor` is required
as it enforces service authentication. 

See [run.dart](fig_auth/example/bin/run.dart) for a complete example.


### Session Management

`fig_auth` provides a simple session management service. Sessions are cached in 
in-memory and persisted to a sqllite database. You can retrieve session information 
in your gRPC methods, including OIDC claims. In particular, the OIDC subject can
be used as a user key in your database.  See [the service example](fig_auth/example/lib/example_svc.dart) 

Your sample utility method looks something like:

```dart

/// Example method to fetch the callers context
/// Your service methods call this at the start of each method.
Future<Session> getSession(ServiceCall call) async {
 var s = await sessionManager.getSession(call.clientMetadata?['authorization'] ?? '');
 if( s == null ) {
  throw GrpcError.internal('Session could not be found');
 }
 // You might want to look up Application info from the database,
 // and return it to each one of your gRPC calls. 
 return s; // For now - just return the Session.
}
```

In your gRPC method, you would call this:

```dart
// If the method is authenticated, the call to getSession should always work..
@override
Future<HelloResponse> hello(ServiceCall call, Hello request) async {
 // get the session context...
 var session = await getSession(call)
 // do something with session.claims, session.subject, etc....
```

## fig_flutter

The Flutter client package that integrates with the `fig_auth` service.

fig_flutter delegates authentication to Firebase using the FlutterFire UI. On succesfull 
authentication, the OIDC token obtained from Firebase will be sent to the `fig_auth` service
for validation. A session will be created, and the session cookie sent back to the client.

A provided gRPC client interceptor will inject the session token into the `Authorization` header
in subsequent calls to your gRPC services. 

See the [example Flutter application](fig_flutter/example/lib/main.dart). 