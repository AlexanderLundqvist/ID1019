defmodule Huffman do

  @doc """
  Sample text used for building the Huffman tree and
  encoding/decoding tables. Contains only the lowercase
  characters of the English alphabet.
  """
  def sample() do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  @doc """
  A sample text to verify the encoding and decoding functions.
  """
  def text() do
    'this is something that we should encode'
  end

  @doc """
  A simple program flow that tests the Huffman algorithm
  with the hardcoded smples.
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
  Part of the tree building procedure. Gets the character frequencies
  and calls huffman with the list to continue the building process.
  """
  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  @doc """
  Calculates the frequency of each character in the given sample text.
  """
  def freq(sample) do
    freq(sample, [])
  end
  def freq([], freq) do
    freq
  end
  def freq([char | rest], freq) do
    freq(rest, update(char, freq))
  end

  defp update(char, []) do
    [{char, 1}]
  end
  defp update(char, [{char, n} | freq]) do
    [{char, n + 1} | freq]
  end
  defp update(char, [elem | freq]) do
    [elem | update(char, freq)]
  end

  @doc """
  Builds the Huffman tree using the given character frequencies.
  """
  def huffman(freq) do
    sorted = Enum.sort(freq, fn {_, x}, {_, y} -> x < y end)
    huffman_tree(sorted)
  end
  defp huffman_tree([{tree, _}]), do: tree
  defp huffman_tree([{a, af}, {b, bf} | rest]) do
    huffman_tree(insert({{a, b}, af + bf}, rest))
  end
  defp insert({a, af}, []), do: [{a, af}]
  defp insert({a, af}, [{b, bf} | rest]) when af < bf do
    [{a, af}, {b, bf} | rest]
  end
  defp insert({a, af}, [{b, bf} | rest]) do
    [{b, bf} | insert({a, af}, rest)]
  end

  @doc """
  Generates an encoding table from the given Huffman tree.
  """
  def encode_table(tree), do: codes(tree, [])

  def codes({a, b}, current_position) do
    as = codes(a, [0 | current_position])
    bs = codes(b, [1 | current_position])
    as ++ bs
  end
  def codes(a, code) do
    [{a, Enum.reverse(code)}]
  end

  @doc """
  Encodes the input text using the given encoding table.
  """
  def encode([], _), do: []
  def encode([char | rest], table) do
    {_, code} = List.keyfind(table, char, 0)
    code ++ encode(rest, table)
  end

  @doc """
  Generates a decoding table from the given Huffman tree.
  """
  def decode_table(tree), do: codes(tree, [])

  @doc """
  Decodes the encoded text using the given decoding table.
  """
  def decode([], _), do: []
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 1) do
      {char, _} ->
        {char, rest}
      nil ->
        decode_char(seq, n + 1, table)
    end
  end

  @doc """
  Benchmarks the program performance by encoding and decoding
  'n' bits text file and prints various performance statistics.
  """
  def bench(n) do
    bench("./kallocain.txt", n)
  end
  def bench(file, n) do
    {text, b} = read(file, n)
    c = length(text)
    {tree, t2} = time(fn -> tree(text) end)
    {encode, t3} = time(fn -> encode_table(tree) end)
    s = length(encode)
    {decode, _} = time(fn -> decode_table(tree) end)
    {encoded, t5} = time(fn -> encode(text, encode) end)
    e = div(length(encoded), 8)
    r = Float.round(e / b, 3)
    {_, t6} = time(fn -> decode(encoded, decode) end)

    IO.puts("text of #{c} characters")
    IO.puts("tree built in #{t2} ms")
    IO.puts("table of size #{s} in #{t3} ms")
    IO.puts("encoded in #{t5} ms")
    IO.puts("decoded in #{t6} ms")
    IO.puts("source #{b} bytes, encoded #{e} bytes, compression #{r}")
  end

  # Measure the execution time of a function.
  def time(func) do
    initial = Time.utc_now()
    result = func.()
    final = Time.utc_now()
    {result, Time.diff(final, initial, :microsecond) / 1000}
  end

 # Get a suitable chunk of text to encode.
  def read(file, n) do
   {:ok, fd} = File.open(file, [:read, :utf8])
    binary = IO.read(fd, n)
    File.close(fd)

    length = byte_size(binary)
    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, chars, rest} ->
        {chars, length - byte_size(rest)}
      chars ->
        {chars, length}
    end
  end
end
