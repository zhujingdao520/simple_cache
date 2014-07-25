
-module(sc_element_sup).
-behaviour(supervisor).

-export([start_link/0, start_child/1]).

-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    Restart = {simple_one_for_one, 0, 1},
    ChildSpec = [
        {sc_server, {sc_server, start_link, []}, temporary, 2000, worker, [sc_server]}
    ],
    {ok, {Restart, ChildSpec}}.

start_child(Val) ->
    supervisor:start_child(?MODULE, [Val]).
