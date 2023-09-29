-module(homework6_sup).

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    ChildSpec =
        {table_sup,                        % Ідентифікатор дочірнього процесу (атом або індекс)
         {table_sup, start_link, []},      % Функція для створення дочірнього процесу та аргументи
         transient,                        % Стратегія перезапуску (transient)
         5000,                             % Стратегія завершення при зупинці (5000 мс)
         supervisor,                       % Тип дочірнього процесу (worker)
         []},                                                      % Список модулів, які повинні бути завантажені
    Procs = [ChildSpec],
    {ok, {{one_for_one, 1, 5}, Procs}}.
