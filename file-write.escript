#!/usr/bin/env escript

-mode(compile).

-include("bench.hrl").

main(_) ->
  write(1),
  write(10),
  write(100).


write(Threads) ->
   FileName = ".tmp.txt",
   {ok,Bin} = file:read_file("10k.txt"),
   Size = erlang:byte_size(Bin),
   {ok, IoDevice} = file:open(FileName,[write]),
    Fun = fun()-> file:write(IoDevice,Bin) end,
    Cnt = 1000,
    {Time,_} = timer:tc(fun()->  bench("write file",Fun,Cnt,Threads) end),
    file:close(IoDevice),
    Total = erlang:trunc(Size * Cnt / 1024 / 1024) * Threads ,
    Time2 = Time / 1000,
    io:format("threads ~p write ~p MB, cost ~p ms  ~p MB per sec ~n",[Threads,Total, Time2, erlang:trunc( Total * 1000 * 1000/Time)]),
    file:delete(FileName).