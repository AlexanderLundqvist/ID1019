defmodule Shunt do
  @moduledoc """
  TBD
  """


  def find([], []) do [] end
  def find(xs, [y|ys]) do
    {hs, ts} = Train.split(xs, y)
    tn = length(ts)
    hn = length(hs)
    [
      {:one, tn+1},
      {:two, hn},
      {:one, -(tn+1)},
      {:two, -hn} | find(Train.append(hs, ts), ys)
    ]
  end

  @doc """

  """
  def few([], []) do
    []
  end


  def few(xs, [y | ys]) do
    {hs, ts} = Train.split(xs, y)
    n_hs = length(hs)
    n_ts = length(ts)

    moves = [
      {:one, n_ts + 1},
      {:two, n_hs},
      {:one, -(n_ts + 1)},
      {:two, -n_hs}
    ]

    if n_hs == 0 do
      [] ++ few(ts, ys)
    else
      moves ++ few(ts ++ hs, ys)
    end
  end


  def compress(ms) do
    ns = rules(ms)
    if ns == ms do
      ms
    else
      compress(ns)
    end
  end

  def rules([]) do
    []
  end

  def rules([{track, step} | moves]) do
    cond do
      step == 0 ->
        rules(moves)

      moves != [] ->
        [{nextTrack, nextStep} | nextMoves] = moves
        cond do
          track == :one && nextTrack == :one ->
            [{:one, step + nextStep}] ++ rules(nextMoves)
          track == :two && nextTrack == :two ->
            [{:two, step + nextStep}] ++ rules(nextMoves)
          true ->
            [{track, step}] ++ rules(moves)
        end
      true ->
        [{track, step}] ++ rules(moves)
    end
  end

end
