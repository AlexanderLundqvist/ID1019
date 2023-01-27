defmodule Benchmark do



  def bench() do bench(100) end

  def bench(n) do

    # ??
    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]

    :io.format("# benchmark with ~w operations, time per operation in us\n", [n])
    :io.format("~6.s~12.s~12.s~12.s\n", ["n", "add", "lookup", "remove"])
    Enum.each(ls, fn (i) ->
    {i, tla, tll, tlr} = bench(i, n)
    :io.format("~6.w~12.2f~12.2f~12.2f\n", [i, tla/n, tll/n, tlr/n])
    end)

  end

  def bench(i, n) do
    seq = Enum.map(1..i, fn(_) -> :rand.uniform(i) end)

    {tla, tll, tlr}  = bench(seq, n, &EnvList.new/0, &EnvList.add/3, &EnvList.lookup/2, &EnvList.remove/2)
    {tta, ttl, ttr}  = bench(seq, n, &EnvTree.new/0, &EnvTree.add/3, &EnvTree.lookup/2, &EnvTree.remove/2)
    {tma, tml, tmr}  = bench(seq, n, &Map.new/0, &Map.put/3, &Map.get/2, &Map.delete/2)

    {i, tla, tta, tma, tll, ttl, tml, tlr, ttr, tmr}
  end

end
