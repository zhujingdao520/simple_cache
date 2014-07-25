
-module(sc_app).
-behaviour(application).
-export([start/2, stop/1]).


%% -----------------------------------------------------------------------------
%% @doc 返回值必须:{ok, pid()} ,返回值为ok 也不行.
%% @doc 否则 application 启动失败(bad_return)
%% -----------------------------------------------------------------------------
-spec start(integer(), integer()) -> {ok, pid()} | {error, atom()}.
start(_Type, _ArgeType) ->
    sc_store:init(), %% 初始化 ets
    sc_sup:start_link(),
    case sc_sup:start_link() of
        {ok, Pid} ->
            {ok, Pid};
        _Other ->
            {error, error}
    end.

stop([]) ->

    ok.
