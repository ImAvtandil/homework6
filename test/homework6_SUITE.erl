-module(homework6_SUITE).

-export([all/0, homework6_integration_test/1]).

-include_lib("common_test/include/ct.hrl").

all() ->
    [homework6_integration_tests].

homework6_integration_test(_Config) ->
    _Reason = application:start(homework6).
