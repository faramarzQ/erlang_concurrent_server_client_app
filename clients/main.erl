-module(main). 
-export([start/0, bulkRequest/0]). 

%%
%% Print the given String on the Console
%%
printStr(Arg) ->
    io:fwrite(Arg).

%%
%% Print the given Number on the Console
%% 
printNum(Arg) ->
    io:fwrite("~w ~n", [Arg]).

%%
%% Send a Get request
%% 
getRequest() ->
    Key = integer_to_list(getRandomKey()),
    URL = "http://localhost:3000/post?post_id="++Key,

    % send request
    {ok, {{Version, 200, ReasonPhrase}, Headers, Body}} =
        httpc:request(get, {URL, []}, [], []),

    % print details
    printStr(pid_to_list(self())++" | Get | Key : "++Key++" |               Res: "++Body++"\n").

%%
%% Send a Post Request
%% 
postRequest() ->
    Key = integer_to_list(getRandomKey()),
    Text = integer_to_list(getRandomText()),
    URL = "http://localhost:3000/post?post_id="++Key++"&text="++Text,

    % send request
    {ok, {{Version, 200, ReasonPhrase}, Headers, Body}} =
        httpc:request(post, {URL, [], [], ""}, [], []),

    % print details
    printStr(pid_to_list(self())++" | Set | Key : "++Key++" | Text: "++Text++" | Res: "++Body++"\n").

%%
%% Send a Delete Request
%% 
deleteRequest() ->
    Key = integer_to_list(getRandomKey()),
    URL = "http://localhost:3000/post?post_id="++Key,

    % send request
    {ok, {{Version, 200, ReasonPhrase}, Headers, Body}} =
        httpc:request(delete, {URL, [], [], ""}, [], []),

    % print details
    printStr(pid_to_list(self())++" | Del | Key : "++Key++" |               Res: "++Body++"\n").

%%
%% Generate random Key, between 1, 5
%% 
getRandomKey() ->
    io:fwrite("",[]),
    rand:uniform(5).

%%
%% Generate random Number, between 1, 1000000
%% 
getRandomText() ->
    io:fwrite("",[]),
    rand:uniform(100000).

%%
%% Send a Random Get, Post or Delete Request
%% 
randRequest() ->
    Rand = rand:uniform(3),

    case Rand of 
        1 -> getRequest(); 
        2 -> postRequest();
        3 -> deleteRequest()
    end.

%%
%% run a Statement for a Given times
%% 
loop(To) ->
    % Do a random request
    randRequest(),
    
    From = 1,
    if To == From ->
        done;
    true ->
        loop(To-1) end.

%%
%% Execute a Process
%% 
bulkRequest() -> 
    printStr("running pid "++pid_to_list(self())++"\n"),
    loop(2).

%%
%% Start point
%% 
start() -> 
    inets:start(),

    % execute processes
    spawn(?MODULE, bulkRequest, []),
    spawn(?MODULE, bulkRequest, []), 
    spawn(?MODULE, bulkRequest, []), 
    spawn(?MODULE, bulkRequest, []), 
    spawn(?MODULE, bulkRequest, []).