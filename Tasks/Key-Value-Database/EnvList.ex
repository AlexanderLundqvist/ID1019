defmodule EnvList do
  def new() do
    []
  end

  def add([], key, value) do
    [{key,value}]
  end

  def add([], a) do
    a
  end

  def lookup([], ) do

  end

  def remove() do

  end
end
