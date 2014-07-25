
%% 保存所有进程Pid
-module(sc_store).
-export([init/0
        ,insert/2
        ,delete/1
        ,lookup/1
        ]).

init() ->
    ets:new(?MODULE, [public, named_table]).

insert(Key, Pid) ->
    ets:insert(?MODULE, {Key, Pid}).

delete(Pid) ->
    ets:match_delete(?MODULE, {'_', Pid}).

lookup(Key) ->
    case ets:lookup(?MODULE, Key) of
        [] -> {error, error_found};
        [{Key, Pid}] -> {ok, Pid}
    end.
