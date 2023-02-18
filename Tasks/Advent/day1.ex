defmodule Day1 do
  @moduledoc """
  This module solves the problem described in day 1 of the Advent of Code 2022.
  """

  @doc """
  This function finds the elf that is carrying the most calories in their backpack.
  """
  def most_calories(file_path) do
    parse_inventory(file_path)
    |> Enum.map(&Day1.sum_calories/1)
    |> Enum.with_index(1)
    |> Enum.max_by(&elem(&1, 0))
  end

  @doc """
  Reads the inventory file, processes the text and produces a mapping of
  elf ID and the contents of their backpack in the form of an array.
  """
  def parse_inventory(file_path) do
    File.read!(file_path)
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n"))
  end

  @doc """
  This function sums the total calorie count in a given elf's backpack.
  """
  def sum_calories(backpack) do
    backpack
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  @doc """
  Execution of the complete module logic. Assumes that the
  inventory file is placed in the same directory.
  """
  def run() do
    IO.puts("Welcome to day 1 of Advent of Code 2022!")
    IO.puts("The elves default inventory is:")
    File.read!("data.txt") |> IO.puts()
    result = Day1.most_calories("data.txt")
    IO.puts("\nThe elf that carries the most calories is: ")
    IO.inspect(result)
  end

end
