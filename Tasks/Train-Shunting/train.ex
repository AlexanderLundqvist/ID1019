defmodule Train do
  @moduledoc """
  This module represents trains as lists of wagons and it defines operatations we can
  perform on said structures. Wagons are represented as atoms (:a, :b, :c, ...).
  Each wagon in a train must be unique, i.e there can be no duplicates so [:a,:b]
  is a valid configuration but [:a,:a] is not.
  """

  @doc """
  Takes the first n wagons of the train and returns them as a new train.
  If n is greater than the length of the train, it returns the entire train.
  """
  def take(_, 0) do [] end
  def take([head|tail], n) when n > 0 do [head|take(tail, n-1)] end

  @doc """
  Drops the first n wagons of the train and returns the remaining wagons as a new train.
  If n is greater than the length of the train, it returns an empty list.
  """
  def drop(train, 0) do train end
  def drop([_|tail], n) when n > 0 do drop(tail, n-1) end

  @doc """
  Appends the wagons of the train_1 (denoted by [head|tail]) to the end of train_2 and returns the resulting train.
  """
  def append([], train_2) do train_2 end
  def append([head|tail], train_2) do [head|append(tail, train_2)] end

  @doc """
  Checks if the wagon is a member of the train. It returns true if wagon is in the train, and false otherwise.
  """
  def member([], _) do false end
  def member([wagon|_], wagon) do true end
  def member([_|tail], wagon) do member(tail, wagon) end

  @doc """
  Returns the position of the first occurrence of the wagon in the train. The positions are 1-indexed.
  """
  def position([wagon|_], wagon) do 1 end
  def position([_|tail], wagon) do position(tail, wagon) + 1 end

  @doc """
  Returns a tuple with two trains where the first contains all the wagons before the specified wagon and the
  second contains all the wagons after the specified wagon.
  """
  def split(train, wagon) do
    index = position(train, wagon)
    {take(train, index-1), drop(train, index)}
  end

  @doc """
  This function is used when moving trains FROM the main track. It takes
  two arguments: a train (i.e. a list of wagons) and a number n that represents
  the number of wagons to move. The wagons on the main track are in reverse order
  i.e. the first wagon in the list is in the leftmost position on the track.
  When you’re asked to move two wagons to another track you should divide the train
  into two segments; the segment that should remain and the two wagons
  (to the right i.e. in the end of the list) that should be moved.

  For example:
    main([:a, :b, :c, :d], 3) = {0, [:a], [:b, :c, .d]}
    main([:a, :b, :c, :d], 5) = {1, [], [:a, :b, :c, .d]}
  """
  def main([], n) do {n, [], []} end
  def main([head|tail], n) do
    case main(tail, n) do
      {0, remain, take} -> {0, [head|remain], take}
      {n, remain, take} -> {n-1, remain, [head|take]}
    end
  end

end
