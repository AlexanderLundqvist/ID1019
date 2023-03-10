defmodule Shunt do
  @moduledoc """
  This module provides functions to perform shunting moves on trains.
  """

  @doc """
  Given a list of wagons and a train, return a list of moves that will rearrange
  the wagons in the order specified. Each move is a tuple of the form {track, n},
  where track is either :track_1 or :track_2 and n represents the number of wagons to
  be moved in the direction specified by the sign of n.

  ## Examples

      iex> Shunt.find([:b, :a], [:a, :b, :c])
      [{:track_1, 3}, {:track_2, 2}, {:track_1, -3}, {:track_2, -2}]

      iex> Shunt.find([:b], [:a, :b, :c])
      [{:track_1, 3}, {:track_2, 1}, {:track_1, -3}, {:track_2, -1}]
  """
  def find([], []) do [] end
  def find(train_1, [head|tail]) do
    {wagons_before, wagons_after} = Train.split(train_1, head)
    amount_after = length(wagons_after)
    amount_before = length(wagons_before)

    [
      {:track_1, amount_after+1},
      {:track_2, amount_before},
      {:track_1, -(amount_after+1)},
      {:track_2, -amount_before} | find(Train.append(wagons_before, wagons_after), tail)
    ]

  end

  @doc """
  This function is an optimized version of `find/2` that uses a shorter sequence of moves.
  It does this by accounting for wagon that are already in the right place.

  ## Examples

      iex> Shunt.few([:b, :a], [:a, :b, :c])
      [{:track_1, 3}, {:track_2, 2}]

      iex> Shunt.few([:b], [:a, :b, :c])
      [{:track_1, 3}, {:track_2, 1}]
  """
  def few([], []) do [] end
  def few(train_1, [head|tail]) do
    {wagons_before, wagons_after} = Train.split(train_1, head)
    amount_before = length(wagons_before)
    amount_after = length(wagons_after)

    moves = [
      {:track_1, amount_after + 1},
      {:track_2, amount_before},
      {:track_1, -(amount_after + 1)},
      {:track_2, -amount_before}
    ]

    if amount_before == 0 do
      [] ++ few(wagons_after, tail)
    else
      moves ++ few(wagons_after ++ wagons_before, tail)
    end
  end

  @doc """
  Compresses a list of moves by combining adjacent moves of the same type into a single move.
  For example, [{:track_1, 2}, {:track_1, 3}] will be compressed to [{:track_1, 5}].

  ## Examples
      iex> Shunt.compress([{ :track_1, 2 }, { :track_1, 3 }, { :track_2, -2 }])
      [{:track_1, 5}, {:track_2, -2}]
  """
  def compress(ms) do
    ns = rules(ms)
    if ns == ms do
      ms
    else
      compress(ns)
    end
  end

  @doc """
  Applies the compression rules to a list of moves and returns the compressed list.
  """
  def rules([]) do [] end
  def rules([{track, step} | moves]) do
    cond do
      step == 0 ->
        rules(moves)

      moves != [] ->
        [{next_track, next_step} | next_moves] = moves
        cond do
          track == :track_1 && next_track == :track_1 ->
            [{:track_1, step + next_step}] ++ rules(next_moves)
          track == :track_2 && next_track == :track_2 ->
            [{:track_2, step + next_step}] ++ rules(next_moves)
          true ->
            [{track, step}] ++ rules(moves)
        end
      true ->
        [{track, step}] ++ rules(moves)
    end
  end

end
