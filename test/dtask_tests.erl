-module(dtask_tests).

-include_lib("eunit/include/eunit.hrl").

-compile(export_all).

dtask_test_() ->
    {foreach,
     fun start_dtask/0,
     fun stop_dtask/1,
     [
      ?_test(call_with_no_node_fails()),
      ?_test(call_calls_on_the_focused_node()),
      ?_test(cast_casts_on_the_focused_node())
     ]}.

call_with_no_node_fails() ->
    ?assertMatch({error, no_node}, dtask:call(?MODULE, ping_self, [ping])).

call_calls_on_the_focused_node() ->
    dtask:register(node()),
    ?assertMatch(pong, dtask:call(?MODULE, ping_self, [ping])).

cast_casts_on_the_focused_node() ->
    dtask:register(node()),
    ?assertMatch(ok, dtask:cast(?MODULE, ping_self, [ping])).

start_dtask() ->
    {ok, Pid} = dtask:start_link(),
    Pid.

stop_dtask(Pid) ->
    gen_server:call(Pid, stop).

ping_self(Msg) ->
    self() ! Msg,
    pong.
