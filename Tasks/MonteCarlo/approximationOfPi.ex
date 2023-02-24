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
  then return true if the dart hit is inside the circle and false otherwise.
  """
  def dart(r) do
    x = Enum.random(0..r)
    y = Enum.random(0..r)
    x * x + y * y <= r * r
  end

  @doc """

  """
  def round(0, _, a) do ... end

  def round(k, r, a) do
    if ... do
    round(..., ..., ...)
    else
    round(..., ..., ...)
    end
  end


  @doc """

  """
  def rounds(k, j, r) do
    rounds(k, j, 0, r, 0)
  end

  def rounds(0, _, t, _, a) do ... end

  def rounds(k, j, t, r, a) do
  a = round(j, r, a)
  t = t + j
  pi = ...
  :io.format(" ... ", [pi, (pi - :math.pi()])
  rounds(k-1, j, t, r, a)
  end

  # Testing stuff here

end
