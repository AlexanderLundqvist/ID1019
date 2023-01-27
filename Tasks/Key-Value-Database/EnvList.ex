defmodule EnvList do

  # Create a new empty list
  def new() do
    []
  end


  # --------------------- Add ------------------------

  # Adding a key-value pair to an empty list
  def add([], key, value) do
    [{key,value}]
  end

  # Use pattern matching on the parameters. If it finds the key specified, update the
  # value associated with that key.
  def add([{key, _value}|tail], key, value) do
    [{key, value}|tail]
  end

  # Adding a new key-value pair to the list. Head
  # refers to the first {key, value} pair in the list and tail
  # tail is the rest of the list [{key, value}, {key, value}, {key-val....]
  # It will recursivly call the add function and accumulate
  def add([head|tail], key, value) do
    [head|add(tail, key, value)]
  end


  # -------------------- Lookup ----------------------

  # Looking up value for a key in an empty list. Underscored parameter
  # means that we will match for it but disregard it.
  def lookup([], _key) do
    nil
  end

  # Use pattern matching on the parameters. If it finds the key specified, return the
  # value associated with that key. Underscored parameter
  # means that we will match for it but disregard it.
  def lookup([{key, _value}=pair|_tail], key) do
    pair
  end

  # Looking up value for a key in a populated list. Recursivly calls lookup with
  # the tail part and specified key. Underscored parameter
  # means that we will match for it but disregard it.
  def lookup([_head|tail], key) do
    lookup(tail, key)
  end


  # -------------------- Remove ----------------------

  # Remove a key-value pair from an empty list. Underscored parameter
  # means that we will match for it but disregard it.
  def remove([], _key) do
    nil
  end

  # Use pattern matching on the parameters, if it finds the key specified, return the tail
  # i.e the rest of the list and by doing so we have removed the element.
  def remove([{key, _value}|tail], key) do
    tail
  end

  # Remove a key-value pair by recursivly calling remove with the tail part and the specified key.
  # It uses accumulation to garantuee tail-recursion.
  def remove([head|tail], key) do
    [head|remove(tail, key)]
  end


end
