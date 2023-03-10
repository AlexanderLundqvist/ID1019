defmodule Huffman do
  @moduledoc """
  TBD
  """

  @doc """
  TBD
  """
  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  @doc """
  TBD
  """
  def text() do
    'this is something that we should encode'
  end

  @doc """
  TBD
  """
  def test do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = text()
    seq = encode(text, encode)
    decode(seq, decode)
  end

  @doc """
  TBD
  """
  def tree(sample) do
  # To implement...
  end

  @doc """
  TBD
  """
  def encode_table(tree) do
  # To implement...
  end

  @doc """
  TBD
  """
  def decode_table(tree) do
  # To implement...
  end

  @doc """
  TBD
  """
  def encode(text, table) do
  # To implement...
  end

  @doc """
  TBD
  """
  def decode(seq, tree) do
  # To implement...
  end

end
