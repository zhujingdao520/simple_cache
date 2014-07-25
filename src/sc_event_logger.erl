
-module(sc_event_logger).
-behaviour(gen_event).

%% API
-export([add_handler/0
        ,delete_handler/0
        ]).

%% CALLBACK
-export([init/1
        ,handle_event/2
        ,handle_info/2
        ,handle_call/2
        ,terminate/2
        ,code_change/3
    ]).

add_handler() ->
    sc_event:add_handler(?MODULE, []).

delete_handler() ->
    sc_event:delete_handler(?MODULE, []).

init([]) ->
    {ok, []}.

handle_event({insert, Key, Val}, State) ->
    error_logger:info_msg("[insert succ [key:~p value:~p]]~n",[Key, Val]),
    {ok,State};
handle_event({delete, Key}, State) ->
    error_logger:info_msg("[delete succ [key:~p]]~n",[Key]),
    {ok,State};
handle_event(_Event, State) ->
    {ok, State}.

handle_call(_Request, State) ->
    {ok, State, State}.

handle_info(_Info, State) ->
    {ok, State}.

terminate(_Reason, State) ->
    {stop, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

