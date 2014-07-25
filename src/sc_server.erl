
-module(sc_server).
-behaviour(gen_server).

%% API
-export([start_link/1
        ,create/1
        ,fetch/1
        ,replace/2
        ,delete/1
        ]).

%% CALLBACK
-export([init/1
        ,handle_call/3
        ,handle_cast/2
        ,handle_info/2
        ,terminate/2
        ,code_change/3
        ]).

-define(TIMEOUT, 600).

%% 记录数据
-record(state, {value = 0, start_time = 0, last_time = 0}).

create(Val) ->
    sc_element_sup:start_child(Val).

start_link(Val) ->
    gen_server:start_link(?MODULE, [Val], []).

init([Val]) ->
    CurrTime = calendar:datetime_to_gregorian_seconds(calendar:local_time()),
    State = #state{value = Val
                , start_time = CurrTime
                , last_time = CurrTime + ?TIMEOUT
    },
    {ok, State, time_left(CurrTime, State#state.last_time)}.

handle_call({fetch}, _From, #state{value = Val} = State) ->
    CurrTime = State#state.start_time,
    Lease_Time = State#state.last_time,
    {reply, {ok, Val}, State, time_left(CurrTime, Lease_Time)};
handle_call(_Request, _From, State) ->
    {reply, State, State}.

handle_cast({replace, Val}, State) ->
    NewState = State#state{value = Val},
    {noreply, NewState};
handle_cast({delete}, State) ->
    sc_store:delete(self()),
    {stop, normal, State};
handle_cast(timeout, State) ->
    sc_store:delete(self()),
    {stop, normal, State};
handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, State) ->
    {normal, State}.

code_change(_VSNold, State, _Extra) ->
    {ok, State}.

%% -----------------------------------------------------------------------------
%% API 接口
%% -----------------------------------------------------------------------------
time_left(Start_Time, Lease_Time) ->
    CurrTime = calendar:datetime_to_gregorian_seconds(calendar:local_time()),
    case Lease_Time - CurrTime of
        Time when Time =< 0 -> 0;
        _Type -> (Lease_Time - Start_Time) * 1000
    end.

fetch(Pid) ->
    gen_server:call(Pid, {fetch}).

replace(Pid, Val) ->
    gen_server:cast(Pid, {replace, Val}).

delete(Pid) ->
    gen_server:cast(Pid, {delete}).




