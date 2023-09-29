-module(table_SUITE).

-export([all/0, white_box_tests/1, black_box_tests/1]).

-include_lib("common_test/include/ct.hrl").

all() ->
    [white_box_tests, black_box_tests].

white_box_tests(_Config) ->
    {ok, _Pid} = table:start_link(table1),
    {ok, _State} = table:init([table1]),
    {noreply, dummy_state} = table:handle_info(dummy_info, dummy_state).

black_box_tests(_Config) ->
    {ok, GenServer} = table:start_link(table1),
    table1 = gen_server:call(GenServer, hello).
