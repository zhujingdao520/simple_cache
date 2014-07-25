
-module(sc_sup).
-behaviour(supervisor).
-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    Restarts = {one_for_one, 4, 3600},
    Childspec = [
        {sc_element_sup, {sc_element_sup, start_link, []}, permanent, 2000, supervisor, [sc_element_sup]}
        ,{sc_event, {sc_event, start_link, []}, permanent, 2000, worker, [sc_event]}
    ],
    {ok, {Restarts, Childspec}}.