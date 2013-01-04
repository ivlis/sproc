
-module(sproc_srv).

-behaviour(gen_server).

%%%%%%%%%%%%%%%%%%%%%%%%%%%% gen_server callbacks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, 
		code_change/3]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OTP interface %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-export([start_link/0]).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE,[], []).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

init([]) -> 
	sproc = ets:new(sproc, [set, protected, named_table]),
	{ok, []}. 

handle_call({reg, Name, Pid}, _From, []) ->
	Reply =
		case ets:match_object(sproc, {Name, '_'}) of
			[] ->
				true = ets:insert(sproc, {Name, Pid}),
				_Ref = erlang:monitor(process, Pid),
				ok;
			_List -> 
				name_already_in_use
		end,
	{reply, Reply, []};
handle_call(stop, _From, State) ->
	{stop, normal, ok, State}.

handle_cast({unreg, Name}, []) ->
	ets:match_delete(sproc, {Name, '_'}),
	{noreply, []};
handle_cast(_Message, State) ->
	{noreply, State}.

handle_info({'DOWN', _Ref, process, Pid, _}, State) ->
	ets:match_delete(sproc,{'_', Pid}),
	{noreply, State};
handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.
