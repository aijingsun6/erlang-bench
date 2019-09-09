#!/usr/bin/env escript

-mode(compile).

file_name(N) ->
  lists:flatten(io_lib:format("tmp.~p.txt",[N])).

rename(N,Max) when N >= Max ->
  FileName = file_name(N),
  io:format("delete ~s ~n",[FileName]),
  file:delete(FileName);
rename(N,Max) ->
  N2 = N + 1,
  FN1 = file_name(N),
  FN2 = file_name(N2),
  io:format("rename ~s -> ~s ~n",[FN1, FN2]),
  file:rename(FN1,file_name(FN2)),
  rename(N2,Max).

rename(N) when N > 1 ->
   FileName = file_name(N),
   Ori = "10k.txt",
   io:format("copy ~s -> ~s ~n",[Ori, FileName]),
   file:copy(Ori ,FileName),
  {Time,_} = timer:tc( fun()-> rename(1,N) end),
  QPS = erlang:trunc(N * 1000 * 1000 / Time),
  io:format("rename ~p times cost ~p ms ~p operations per sec ~n",[N, erlang:trunc( Time/1000 ), QPS]).

main(_) ->
  rename(10000).

