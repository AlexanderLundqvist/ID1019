defmodule Train do
  @moduledoc """
  This module represents our trains and it defines operatations we can perform on the train
  structure that the train is represented by.
  """

  @doc """
  Returns the first n wagons of a train if n <= the lenght of the train, otherwise
  return the entire train.
  """
  def take(_, 0) do [] end

  @doc """
  Returns the first n wagons of a train if n <= 0, otherwise return the .
  If n is greater than 0, returns a train containing the first n wagons.
  """
  def take([h|t], n) when n > 0 do [h|take(t, n-1)] end

  @doc """
  Detatches the first n wagons of a train.
  If n is zero, returns the entire train.
  """
  def drop(lst, 0) do lst end

  @doc """
  Detatches the first n wagons of a train.

  If n is greater than 0, drops the first n wagons and returns the rest of the train.
  """
  def drop([_|t], n) when n > 0 do drop(t, n-1) end

  @doc """
  Appends two trains.

  If the first train is empty, returns the second train.
  """
  def append([], ys) do ys end

  @doc """
  Appends two trains.

  If the first train is not empty, appends the first train and the second train.
  """
  def append([h|t], ys) do [h|append(t,ys)] end

  @doc """
  Checks if an element is a member of a train.

  If the train is empty, returns false.
  """
  def member([],_) do false end

  @doc """
  Checks if an element is a member of a train.

  If the element is the first element of the train, returns true.
  """
  def member([y|_], y) do true end

  @doc """
  Checks if an element is a member of a train.

  If the element is not the first element of the train, checks the rest of the train.
  """
  def member([_|t], y) do member(t, y) end

  @doc """
  Returns the position of an element in a train.

  If the element is the first element of the train, returns 1.
  """
  def position([y|_], y) do 1 end

  @doc """
  Returns the position of an element in a train.

  If the element is not the first element of the train, adds 1 to the position of the element in the rest of the train.
  """
  def position([_|t], y) do position(t, y) + 1 end

  @doc """
  Splits a train into two trains at the position of an element.
  Returns a tuple containing the first part of the train before the element and the second part of the train after the element.
  """
  def split(train, y) do
    n = position(train, y)
    {take(train, n-1), drop(train, n)}
  end

end
