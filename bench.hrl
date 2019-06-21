%% @doc bench with single thread
bench(Name, Fun, Trials) ->
  bench(Name, Fun, Trials, 1).

%% @doc bench with multi thread
bench(Name, Fun, Trials, Threads) ->
  print_result(Name, repeat_tc(Fun, Trials, Threads)).

repeat_tc(Fun, Trials, Threads) when Threads < 2 ->
  % only one thread
  {Time, _} = timer:tc(fun() -> repeat(Trials, Fun) end),
  {Time, Trials};
repeat_tc(Fun, Trials, Threads) ->
  {Time, _} = timer:tc(
    fun() ->
      PID = self(),
      do_map(Threads, PID, Fun, Trials),
      do_reduce(Threads)
    end),
  {Time, Trials * Threads}.

repeat(0, _Fun) -> ok;
repeat(N, Fun) -> Fun(), repeat(N - 1, Fun).

print_result(Name, {Time, Trials}) when Time =/= 0 ->
  io:format("~s: ~.3f us (~.2f per second)~n", [Name, Time / Trials, Trials / (Time / 1000000)]);
print_result(_, _) ->
  ok.

do_map(0, _PID, _F, _Trials) -> ok;
do_map(N, PID, F, Trials) ->
  erlang:spawn(fun() -> repeat_tc(F, Trials, 1), PID ! ok end),
  do_map(N - 1, PID, F, Trials).

do_reduce(0) -> ok;
do_reduce(N) ->
  receive
    _ -> do_reduce(N - 1)
  end.