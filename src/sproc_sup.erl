
-module(sproc_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

start_link() ->
    supervisor:start_link(?MODULE, []).


init([]) ->
	Children =
		[
			{sproc_srv,
				{sproc_srv, start_link, []},
				permanent, 1000, worker, [sproc_srv]}
		],
	{ok, { {one_for_all, 5, 10}, Children} }.

