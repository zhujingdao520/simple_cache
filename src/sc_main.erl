-module(sc_main).
-export([start/0]).

start() ->
    application:start(sc_main)
.