defmodule Hanoi do
  # Let’s implement a function that returns the sequence of moves necessary to
  # solve towers of Hanoi of a given size n. The pegs are called :a, :b and :c
  # and a move is represented by a tuple {:move, from, to} meaning that the
  # uppermost disc on the from peg is moved to the to peg.

  # If we try to solve for zero discs, then there won't be any moves.
  # This is the base case for the recursion.
  defp solve(0, _, _, _) do [] end

  # Recursively solves the Hanoi puzzle with the least amount of moves
  # for a puzzle with n amount of discs and adds the moves to a list.
  defp solve(n, left, middle, right) do
    # Move the discs until we have the largest one left on the first peg
    solve(n-1, left, right, middle) ++

    # We can now move the largest one to the third peg
    [{:move, left, right}] ++

    # Then we move the rest of the discs to the third peg
    solve(n-1, middle, left, right)
  end

  # Let's the user input the amount of discs then solve the puzzle.
  def run() do
    IO.puts("Welcome to the Towers of Hanoi puzzle solver!")
    IO.puts("The puzzle currently has 3 pegs.")
    input = IO.gets("Enter the number of discs you want to solve for: ")
    input = String.trim(input)
    case Integer.parse(input) do
      {integer, _} ->
        solve(integer, :left, :middle, :right)
      _ ->
        IO.puts("Invalid input. Not a number.")
    end
  end

end
