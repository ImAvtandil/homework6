-module(homework6_SUITE).

-export([all/0, init_per_suite/1, end_per_suite/1, homework6_integration_tests/1]).

-include_lib("common_test/include/ct.hrl").

all() ->
    [homework6_integration_tests].

init_per_suite(Config) ->
    ok = application:start(homework6),
    Config.

homework6_integration_tests(_Config) ->
    ok = homework6:create(table1),
    ok = homework6:insert(table1, 1, 1),
    1 = homework6:lookup(table1, 1),
    ok = homework6:insert(table1, 2, 2, 2),
    2 = homework6:lookup(table1, 2),
    timer:sleep(3000),
    undefined = homework6:lookup(table1, 2),
    [{1, _, 1}, {2, _, 2}] = ets:tab2list(table1),
    table1 ! clear,
    timer:sleep(300),
    [{1, _, 1}] = ets:tab2list(table1).

end_per_suite(Config) ->
    ok = application:stop(homework6),
    Config.
