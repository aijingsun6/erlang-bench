#!/usr/bin/env escript

-mode(compile).

write_n(N,Max,_IoDevice,_Bin) when N > Max -> ok;
write_n(N,Max,IoDevice,Bin) ->
   file:write(IoDevice,Bin),
   write_n(N+1,Max,IoDevice,Bin).

write_file(FileName, N) ->
   {ok,Bin} = file:read_file("10k.txt"),
   {ok, IoDevice} = file:open(FileName,[write]),
   {Time,_} = timer:tc(fun()-> write_n(1,N,IoDevice,Bin) end),
   file:close(IoDevice),
   file:delete(FileName),
   Time / 1000.

file_name(N) ->
  lists:flatten(io_lib:format("tmp.~p.txt",[N])).

write_multi(N, FileSize)->
  N2 = N div FileSize,
  L = lists:map(fun(X) -> {file_name(X),N2} end, lists:seq(1,FileSize)),
  P = self(),
  F = fun()-> write_multi_map(L,P),write_multi_receive(0,FileSize) end,
  {Time,_} = timer:tc(F),
   io:format("write to ~p files ~p times, cost ~p ms ~n",[FileSize, N,Time/1000]).

write_multi_map([],_PID)-> ok;
write_multi_map([{FileName,N}|L],PID)->
  erlang:spawn(fun()-> write_file(FileName,N), PID ! ok end),
  write_multi_map(L,PID).

write_multi_receive(Cnt,Max) when Cnt >= Max -> ok;
write_multi_receive(Cnt,Max) ->
  receive
    Msg -> write_multi_receive(Cnt+1,Max)
  end.

main(_) ->
  N  = 10000,
  write_multi(N,1),
  write_multi(N,2),
  write_multi(N,4),
  write_multi(N,5),
  write_multi(N,8).