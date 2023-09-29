-module(homework6).

-export([create/1, insert/3, insert/4, lookup/2, getCurrentTime/0]).

-include_lib("stdlib/include/ms_transform.hrl").

create(TableName) ->
    supervisor:start_child(table_sup, [TableName]),
    ok.

insert(TableName, Key, Value) ->
    ets:insert_new(TableName, {Key, 0, Value}),
    ok.

insert(TableName, Key, Value, Expire) ->
    ExpireTime = getCurrentTime() + Expire,
    ets:insert_new(TableName, {Key, ExpireTime, Value}),
    ok.

lookup(TableName, Key) ->
    Time = getCurrentTime(),
    case ets:lookup(TableName, Key) of
        [{Key, Expire, Value}] when Expire > Time ->
            Value;
        [{Key, 0, Value}] ->
            Value;
        _ ->
            undefined
    end.

getCurrentTime() ->
    calendar:datetime_to_gregorian_seconds(
        calendar:universal_time()).
