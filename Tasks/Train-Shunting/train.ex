defmodule Train do
  @moduledoc """
  This module represents trains as lists of wagons and it defines operatations we can
  perform on said structures.
  """

  @doc """
  """
  def take(_, 0) do [] end
  def take([head|tail], n) when n > 0 do [head|take(tail, n-1)] end

  @doc """

  """
  def drop(list, 0) do lst end
  def drop([_|tail], n) when n > 0 do drop(tail, n-1) end

  @doc """

  """
  def append([], secondTrain) do secondTrain end
  def append([head|tail], secondTrain) do [head|append(tail, secondTrain)] end

  @doc """

  """
  def member([], _) do false end
  def member([y|_], y) do true end
  def member([_|tail], y) do member(tail, y) end

  @doc """

  """
  def position([y|_], y) do 1 end
  def position([_|tail], y) do position(tail, y) + 1 end

  @doc """

  """
  def split(train, y) do
    n = position(train, y)
    {take(train, n-1), drop(train, n)}
  end

end
