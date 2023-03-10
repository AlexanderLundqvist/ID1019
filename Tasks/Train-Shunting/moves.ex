defmodule Moves do
  @moduledoc """
  This module represents the moves we can perform on the trains at the train shunting
  yard, represented as a tuple of three lists:
    - the main track
    - track_1
    - track_2
  Moves are defined as a tuple of an atom (:track_1 or :track_2) and an integer n,
  where n represents the number of wagons to move and the sign represents in which
  direction the move is. Positive values of n represent a move to the right (from the main track to
  the specified shunting track), while negative values of n represent a move
  to the left (from the specified shunting track to the main track).
  """

  @doc """
  Executes a single move on a train shunting yard state. It takes a move and an
  input state (where the state is a list of three lists representing the train tracks)
  and return a new state after the move has been performed.

  ## Examples

      iex> Moves.single({:track_1, 2}, {[1,2,3,4], [5,6,7], [8,9,10]})
      {[3,4], [5,6,7,1,2], [8,9,10]}

      iex> Moves.single({:track_2, -1}, {[1,2,3], [4,5,6], [7,8,9,10]})
      {[1,2,3,6], [4,5], [7,8,9,10]}
  """
  # If we move zero wagons, then nothing has changed and we return the same state.
  def single({_, 0}, state) do state end

  # If n is positive, move n wagons from main track to track_1
  def single({:track_1, n}, {main, track_1, track_2}) when n > 0 do
    {0, remain, wagons} = Train.main(main, n)
    {remain, Train.append(wagons, track_1), track_2}
  end

  # If n is negative, move |n| wagons from track_1 to main track
  def single({:track_1, n}, {main, track_1, track_2}) when n < 0 do
    wagons = Train.take(track_1, -n)
    {Train.append(wagons, main), Train.drop(track_1, -n), track_2}
  end

  # If n is positive, move n wagons from main track to track_2
  def single({:track_2, n}, {main, track_1, track_2}) when n > 0 do
    {0, remain, wagons} = Train.main(main, n)
    {remain, track_1, Train.append(wagons, track_2)}
  end

  # If n is negative, move |n| wagons from track_2 to main track
  def single({:track_2, n}, {main, track_1, track_2}) when n < 0 do
    wagons = Train.take(track_2, -n)
    {Train.append(wagons, main), track_1, Train.drop(track_2, -n)}
  end


  @doc """
  Executes a sequence of moves on a train shunting yard state. It takes
  a list of moves and a track state and returns a list of states representing
  the intermediate states after each move is applied.

  ## Example from the assignment instructions
  iex> Moves.sequence([{:track_1,1},{:track_2,2},{:track_1, -1},{:track_2,-2},{:track_1,1},
                       {:track_2,1}, {:track_1,-1},{:track_2,-1}],{[:a,:b,:c],[],[]})

    [
      {[:a, :b, :c], [], []},
      {[:a, :b], [:c], []},
      {[], [:c], [:a, :b]},
      {[:c], [], [:a, :b]},
      {[:c, :a, :b], [], []},
      {[:c, :a], [:b], []},
      {[:c], [:b], [:a]},
      {[:c, :b], [], [:a]},
      {[:c, :b, :a], [], []}
    ]
  """
  def sequence([], state) do [state] end
  def sequence([move|rest], state) do
    [state | sequence(rest, single(move, state))]
  end

end
