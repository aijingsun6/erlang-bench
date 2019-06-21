This is an assortment of Erlang rellated benchmarks

Assuming you have Erlang installed, you can just execute the applicable escript
to view the results.

Of course, review the source before you execute anything!

### exe result on my machine
```
cpu: Intel(R) Core(TM) i5-4590 CPU @ 3.30GHz * 4
memory:7951064 kB
```


##### ```binary-join```
```
iolist_to_binary: 7.590 us (131752.31 per second)
binary_append: 35.901 us (27854.61 per second)
```
##### ```binary-match```
```
binary_match_compiled: 0.550 us (1819306.48 per second)
binary_match_uncompiled: 0.543 us (1843114.13 per second)
scan_split: 22.044 us (45364.13 per second)
scan_part: 10.944 us (91371.35 per second)
scan_pattern: 19.075 us (52425.49 per second)
```