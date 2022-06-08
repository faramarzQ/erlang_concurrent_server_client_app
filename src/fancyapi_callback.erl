-module(fancyapi_callback).
-export([handle/2, handle_event/3]).

-include_lib("elli/include/elli.hrl").
-behaviour(elli_handler).

handle(Req, _Args) ->
    %% Delegate to our handler function
    handle(Req#req.method, elli_request:path(Req), Req).

%%
%% Store post with id and text
%% 
handle('POST',[<<"post">>], Req) ->

    PostID = elli_request:get_arg(<<"post_id">>, Req, <<"undefined">>),
    Text = elli_request:get_arg(<<"text">>, Req, <<"undefined">>),

    % store key value in Redis
    {ok, C} = eredis:start_link(),
    {ok, <<"OK">>} = eredis:q(C, ["SET", PostID, Text]),

    % publish this event on a channel
    eredis:q(C, ["PUBLISH", "c1", string:concat("SET | ID: ", PostID)]),

    {ok, [], <<"Stored">>};

%%
%% Get post with a specific id
%% 
handle('GET',[<<"post">>], Req) ->

    PostID = elli_request:get_arg(<<"post_id">>, Req, <<"undefined">>),

    % get value by key from Redis
    {ok, C} = eredis:start_link(),
    {ok, Value} = eredis:q(C, ["GET", PostID]),

    % publish this event on a channel
    eredis:q(C, ["PUBLISH", "c1", string:concat("GET | ID: ", PostID)]),

    {ok, [], Value};

%%
%% Delete post with a specific id
%% 
handle('DELETE',[<<"post">>], Req) ->

    PostID = elli_request:get_arg(<<"post_id">>, Req, <<"undefined">>),

    % delete a value by key from Rrdis
    {ok, C} = eredis:start_link(),
    {ok, <<"OK">>} = eredis:q(C, ["SET", PostID, ""]),

    % publish this event on a channel
    eredis:q(C, ["PUBLISH", "c1", string:concat("DEL | ID: ", PostID)]),

    {ok, [], <<"Deleted">>};

handle(_, _, _Req) ->
    {404, [], <<"Not Found!">>}.

%% @doc Handle request events, like request completed, exception
%% thrown, client timeout, etc. Must return `ok'.
handle_event(_Event, _Data, _Args) ->
    ok.