#!/usr/bin/env escript
-mode(compile).
-include("bench.hrl").

main(_) ->
  Ref = atomics:new(1,[]),
  ets:new(id_gen_ets,[named_table,set,public]),
  ets:insert(id_gen_ets,{1,0}),
  Pid = erlang:spawn(fun()-> loop(0) end),
  Cnt = 10000,
  Threads = 100,
  LastId = Cnt*Threads,
  bench(io_lib:format("gen_with_ets, ~p * ~p",[Cnt,Threads]),fun()-> gen_with_ets() end, Cnt   ,Threads),
  bench(io_lib:format("gen_with_atomics, ~p * ~p",[Cnt,Threads]),fun()-> gen_with_atomics(Ref) end,Cnt , Threads),
  bench(io_lib:format("gen_with_proc, ~p * ~p",[Cnt,Threads]),fun()-> gen_with_proc(Pid) end ,Cnt, Threads),
  [{1,LastId}] = ets:lookup(id_gen_ets,1),
  LastId = atomics:get(Ref,1),
  Pid ! {get,self()},
  receive
    Msg -> LastId = Msg
  end,
  io:format("test passed.~n",[]).

gen_with_proc(Pid) ->
   Pid ! {add,self()},
   receive
     _ -> ok
    end.

gen_with_ets() -> ets:update_counter(id_gen_ets,1,{2,1}).

gen_with_atomics(Ref) ->
  atomics:add_get(Ref,1,1).

loop(N)->
  receive
    {add,From} ->
       N2 = N + 1,
       From ! N2,
       loop(N2);
     {get,From}->
        From ! N,
        loop(N)
   end.
