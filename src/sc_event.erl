
%% 所现事件管理的接口
-module(sc_event).
-compile([export_all]).

-define(SERVER, ?MODULE).

%% 启动一个事件管理器
start_link() ->
    gen_event:start_link({local, ?SERVER}).

%% 添加新的事件对象
add_handler(Hander, Args) ->
    gen_event:add_handler(?SERVER, Hander, Args).

%% 管理器删除事件对象
del_handler(Hander, Args) ->
    gen_event:delete_handler(?SERVER, Hander, Args).

%% 事件通知
insert(Key, Val) ->
    gen_event:notify(?SERVER, {insert, Key, Val}).

%% 事件通知
delete(Key) ->
    gen_event:notify(?SERVER, {delete, Key}).
