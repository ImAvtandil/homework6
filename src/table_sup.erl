-module(table_sup).

-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    ChildSpecs =
        [#{id => table,
           start => {table, start_link, []},
           shutdown => brutal_kill}],
    % Procs = [],
    {ok, {{simple_one_for_one, 0, 5}, ChildSpecs}}.
