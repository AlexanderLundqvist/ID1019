defmodule EnvTree do
  '''
  Node structure is represented as {:node, key, value, left, right}.
  '''

  # Create a new empty tree structure
  def new() do
    nil
  end


  # --------------------- Add ------------------------

  '''
  The tree should of course be sorted to make the lookup operation efficient.
  You do not have to implement a balanced tree but this would of course
  be something that one would need to consider.
  Identify the base cases and then how to recurse down the right or left
  branch.
  Remember that we are in fact not ”updating” the tree that we have
  but rather constructing a copy of the tree where we have added the new
  key-value pair.
  '''

  # Adding a key-value pair to an empty tree. Returns a single node with
  # left and right pointing to null/nil
  def add(nil, key, value) do
    {:node, key, value, nil, nil}
  end

  # If we found the key then we can just replace the value with the new one
  def add({:node, key, _value, left, right}, key, value) do
    {:node, key, value, left, right}
  end

  # Now, as we are trying to keep the tree sorted, we want to branch keys
  # smaller than the key of the current node to the left.
  def add({:node, currentKey, currentValue, left, right}, key, value) when key < currentKey do
    {:node, currentKey,  currentValue, add(left, key, value), right}
  end

  # And for keys larger than the current node's, we branch right.
  def add({:node, currentKey, currentValue, left, right}, key, value) do
    {:node, currentKey,  currentValue, left, add(right, key, value)}
  end

  # -------------------- Lookup ----------------------

  '''
  Implementing lookup/2 is very similar to the add/3 function. The difference
  is of course that we are not building a new tree but returning the
  found key-value pair or nil if not found.
  '''

  # Looking up value for a key in an empty tree. Underscored parameter
  # means that we will match for it but disregard it.
  def lookup(nil, _key) do
    nil
  end

  # If the key of the node corresponds to the searched key,
  # we can return the value.
  def lookup({:node, key, value, _left, _right}, key) do
    {key, value}
  end

  # If the searched key is smaller than the current node, traverse the left branch.
  def lookup({:node, currentKey, _currentValue, left, _right}, key) when key < currentKey do
    lookup(left, key)
  end

  # If the searched key is larger than the current node, traverse the right branch.
  def lookup({:node, _currentKey, _currentValue, _left, right}, key) do
    lookup(right, key)
  end

  # -------------------- Remove ----------------------

  '''
  The idea is to first locate the key to
  remove and then replace it with the leftmost key-value pair in the right
  branch (or the rightmost in the left branch). Removing and returning the
  leftmost key-value pair should be simple so if you only can handle all special
  cases you should be up an running in a few minutes.
  '''


  # Remove a key-value pair from an empty tree. Underscored parameter
  # means that we will match for it but disregard it.
  def remove(nil, _key) do
    nil
  end

  # If the left branch doesn't exist, "delete" current node by returning the right branch
  def remove({:node, key, _value, nil, right}, key) do
    right
  end

  # If the right branch doesn't exist, "delete" current node by returning the left branch
  def remove({:node, key, _value, left, nil}, key) do
    left
  end

  #
  def remove({:node, key, _value, left, right}, key) do
    {key, value, rest} = leftmost(right)
    {:node, key, value, left, rest}
  end

  # If the key is smaller than the key in the current node, traverse down the left branch
  def remove({:node, currentKey, currentValue, left, right}, key) when key < currentKey do
  {:node, currentKey, currentValue, remove(left, key), right}
  end

  # If the key is greater than the key in the current node, traverse down the right branch
  def remove({:node, currentKey, currentValue, left, right}, key) do
  {:node, currentKey, currentValue, left, remove(right, key)}
  end

  #
  def leftmost({:node, key, value, nil, rest}) do
    {key, value, rest}
  end

  #
  def leftmost({:node, currentKey, currentValue, left, right}) do
    {key, value, rest} = leftmost(left)
    {key, value, {:node, currentKey, currentValue, rest, right}}
  end


end
