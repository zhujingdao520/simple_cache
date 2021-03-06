
-module(sc_rpc).
-compile([export_all]).


insert(Key, Val) ->
    case sc_store:lookup(Key) of
        {ok, Pid} ->
            sc_server:replace(Pid, Val);
        {error, _} ->
            {ok, Pid} = sc_server:create(Val),
            sc_store:insert(Key, Pid),
            sc_event:insert(Key, Val)
    end.

lookup(Key) ->
    case sc_store:lookup(Key) of
        {ok, Pid} ->
            sc_server:fetch(Pid);
        {error, _} ->
            {error, not_fount}
    end.

delete(Key) ->
    case sc_store:lookup(Key) of
        {ok, Pid} ->
            sc_server:delete(Pid),
            sc_event:delete(Key);
        {error, _} ->
            {error, not_fount}
    end.