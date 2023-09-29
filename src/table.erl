-module(table).

-behaviour(gen_server).

-include_lib("stdlib/include/ms_transform.hrl").

%% API.
-export([start_link/1]).
%% gen_server.
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([terminate/2]).
-export([code_change/3]).

-record(state, {table}).

%% API.

start_link(Id) ->
    gen_server:start_link({local, Id}, ?MODULE, [Id], []).

%% gen_server.

init([Tablename]) ->
    createTable(Tablename),
    erlang:send_after(60000, self(), clear),
    {ok, #state{table = Tablename}}.

handle_call(_Request, _From, State) ->
    {reply, State#state.table, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(clear, State) ->
    delete_obsolete(State#state.table),
    erlang:send_after(60000, self(), clear),
    {noreply, State};
handle_info(_, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

createTable(TableName) ->
    case ets:whereis(TableName) of
        undefined ->
            ets:new(TableName, [named_table, public]);
        _ ->
            ok
    end,
    ok.

delete_obsolete(TableName) ->
    Time = homework6:getCurrentTime(),
    Select = ets:fun2ms(fun({_, Expire, _}) when Expire =/= 0, Expire < Time -> true end),
    ets:select_delete(TableName, Select),
    ok.
