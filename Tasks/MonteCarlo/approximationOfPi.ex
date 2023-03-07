defmodule ApproximationOfPi do
  @moduledoc """
  This module implements the Monte Carlo method with dart throwing to estimate
  the value of pi.
  The simulation generates random points in a square and checks whether they
  fall within a quarter-circle of radius r centered at the origin. By comparing
  the number of hits inside the quarter-circle to the total number of darts thrown,
  the simulation can approximate the value of pi.
  """

  @doc """
  Throws a dart at a square board of size 2*r centered at the origin,
  then return true if the dart hit inside the circle and false otherwise.
  """
  def dart(r) do
    x = Enum.random(0..r)
    y = Enum.random(0..r)
    x * x + y * y <= r * r
  end

  @doc """
  A round represents throwing a 'k' amount of darts at the square board with side
  length 'r' (also the radius of the quarter-circle). The amount of darts that hits
  inside of the circle are added to accumulator 'a' which then gets returned.
  """
  def round(0, _, a) do a end # No darts left, return the result

  def round(k, r, a) do
    if dart(r) do
      round(k-1, r, a+1)
    else
      round(k-1, r, a)
    end
  end


  @doc """
  Simulates 'k' rounds of dart throwing with 'j' amount of darts each at the square
  board with side length 'r'. This is the function that the user calls. It will call
  the rounds/5 function that has two additional parameters 't' which is current number
  of darts thrown, and an 'a' which is the amount of darts that has hit inside the
  quarter-circle so far.
  """
  def rounds(k, j, r) do
    rounds(k, j, 0, r, 0)
  end

  defp rounds(0, _, t, _, a) do (4.0 * a / t) end

  defp rounds(k, j, t, r, a) do
    a = round(j, r, a)
    t = t + j
    pi_approx = 4.0 * a / t
    :io.format("Our approximation: ~.10f | Error = ~.10f\n", [pi_approx, abs(pi_approx - :math.pi())])
    rounds(k-1, j, t, r, a)
  end


  @doc """
  This function works the same as rounds, but here we double the amount of darts after
  each round.
  """
  def rounds2(k, j, r) do
    rounds2(k, j, 0, r, 0)
  end

  defp rounds2(0, _, t, _, a) do (4.0 * a / t) end

  defp rounds2(k, j, t, r, a) do
    a = round(j, r, a)
    t = t * 2
    pi_approx = 4.0 * a / t
    :io.format("Our approximation: ~.10f | Error = ~.10f\n", [pi_approx, abs(pi_approx - :math.pi())])
    rounds2(k-1, j, t, r, a)
  end

end
