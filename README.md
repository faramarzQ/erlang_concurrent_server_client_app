# Erlang Client-Server Concurrent Application

This is a Academic project built with Erlang on a simple Client-Server architecture to demonstrate the concurrency concept.    
The client is responsible for creating CRUD calls on the Post resource on the server and the server handles the events by applying the CRUDs on Post resource stored in a Redis server.

## The Client
The client is on pure Erlang, making 5 concurrent CRUD request calls on the server. The CRUD operation are chosen randomly for each API call; for instance one time the sequence of calls might be as follow:
1. `Create post (key: 1, text: 145)`
2. `Create post (key: 2, text: 938)`
3. `Get post (key: 1)`
4. `Delete post (key: 2)`
5. `Get post (key: 2)`

An another run be like the following:    
1. `Delete post (key: 3)`
2. `Create post (key: 1, text: 12)`
3. `Get post (key: 5)`
4. `Create post (key: 4, text: 233)`
4. `Get post (key: 1)`

Key values are randomly selected from `1 to 5` and text values are also randomly selected from `1 to 100000`.    

**Note**: In order to run the client successfully you should have the server running.

### Running The Client
The client's code is in the `clients` directory; Execute the following:    
```
erlc clients/main.erl    
erl -noshell -s main start
```
## The Server

For the server side i've used <a href="https://github.com/erlang/rebar3">Rebar</a> as the package manager and builder tool. i've also used <a href="https://github.com/elli-lib/elli">Elli</a> as my webserver handling the requests. Elli also supports testing tools named as *etest*. Elli writes does the CRUDs on the Redis caching server using <a href="https://github.com/wooga/eredis">Eredis</a> package.    

### APIs
APIs supported by the application is as follow:
- Get a post with the given key (if exists)
- Create a post with the key and text (if the key already exists, just update it)
- Delete a post by the give key (if exists)
### Running The Server

The server is in the `src` directory. The server is instantiated in the `fancyapi_app.erl` file and the handlers for requests are in the `fancyapi_callback.erl` file.    
In order to run the server:    
```
docker-compose up -d    
rebar compile && cd ebin && erl -pa ../deps/*/ebin    
application:start(fancyapi).    
```
