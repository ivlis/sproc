-module(sproc).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% sproc API %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-export([reg/2, where/1]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

reg(Name, Pid) ->
	gen_server:call(sproc_srv, {reg, Name, Pid}).

where(Name) ->
	case ets:match(sproc, {Name, '$1'}) of
		[Pid|_] -> Pid;
		[] -> not_registered
	end.

