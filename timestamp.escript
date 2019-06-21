#!/usr/bin/env escript
-mode(compile).
-include("bench.hrl").

main([CS,TS])->
  Cnt = erlang:list_to_integer(CS),
  Threads = erlang:list_to_integer(TS),
  do_bench(Cnt,Threads);
main(_) ->
  Cnt = 10000,
  Threads = 100,
  do_bench(Cnt,Threads).

do_bench(Cnt,Threads)->
  bench(io_lib:format("timestamp_with_os_perf, ~p * ~p",[Cnt,Threads]),fun timestamp_with_os_perf/0 ,Cnt,Threads),
  bench(io_lib:format("timestamp_with_os_timstamp, ~p * ~p",[Cnt,Threads]),fun timestamp_with_os_timstamp/0,Cnt,Threads),
  bench(io_lib:format("timestamp_with_timstamp, ~p * ~p",[Cnt,Threads]),fun timestamp_with_timstamp/0,Cnt,Threads).

timestamp_with_os_perf()->
  os:perf_counter(second).

timestamp_with_os_timstamp()->
  {A,B,_}=os:timestamp(),
  A*1000000+ B.

timestamp_with_timstamp()->
   {A,B,_}=erlang:timestamp(),
    A*1000000+ B.
