defmodule Morse do
  @moduledoc """
  A Morse module that implements encoding and decoding of Morse code messages.
  """

  # Secret messages to be decoded
  def message_1, do: '.- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ...'
  def message_2, do: '.... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .----'

  @doc """
  Original Morse tree from the assignment. We append either '-' when we go left and '.'
  when we go right, getting progressivly longer the further down the tree we go.
  Returns the Morse code tree structure.
  """
  def morse() do
    {:node, :na,
      {:node, 116,
        {:node, 109,
          {:node, 111,
            {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
            {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
          {:node, 103,
            {:node, 113, nil, nil},
            {:node, 122,
              {:node, :na, {:node, 44, nil, nil}, nil},
              {:node, 55, nil, nil}}}},
        {:node, 110,
          {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
          {:node, 100,
            {:node, 120, nil, nil},
            {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
      {:node, 101,
        {:node, 97,
          {:node, 119,
            {:node, 106,
                  {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
                  nil},
                {:node, 112,
                  {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
                  nil}},
              {:node, 114,
                {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
                {:node, 108, nil, nil}}},
        {:node, 105,
          {:node, 117,
            {:node, 32,
              {:node, 50, nil, nil},
              {:node, :na, nil, {:node, 63, nil, nil}}},
            {:node, 102, nil, nil}},
          {:node, 115,
            {:node, 118, {:node, 51, nil, nil}, nil},
            {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end

  # Morse representation of common characters from appendix.
  defp codes do
    [
      {32, '..--'},   # Space character
      {37, '.--.--'}, # %
      {44, '--..--'}, # ,
      {45, '-....-'}, # -
      {46, '.-.-.-'}, # .
      {47, '.-----'}, # /
      {48, '-----'},  # 0
      {49, '.----'},  # 1
      {50, '..---'},  # 2
      {51, '...--'},  # 3
      {52, '....-'},  # 4
      {53, '.....'},  # 5
      {54, '-....'},  # 6
      {55, '--...'},  # 7
      {56, '---..'},  # 8
      {57, '----.'},  # 9
      {58, '---...'}, # :
      {61, '.----.'}, # =
      {63, '..--..'}, # ?
      {64, '.--.-.'}, # @
      {97, '.-'},     # a
      {98, '-...'},   # b
      {99, '-.-.'},   # c
      {100, '-..'},   # d
      {101, '.'},     # e
      {102, '..-.'},  # f
      {103, '--.'},   # g
      {104, '....'},  # h
      {105, '..'},    # i
      {106, '.---'},  # j
      {107, '-.-'},   # k
      {108, '.-..'},  # l
      {109, '--'},    # m
      {110, '-.'},    # n
      {111, '---'},   # o
      {112, '.--.'},  # p
      {113, '--.-'},  # q
      {114, '.-.'},   # r
      {115, '...'},   # s
      {116, '-'},     # t
      {117, '..-'},   # u
      {118, '...-'},  # v
      {119, '.--'},   # w
      {120, '-..-'},  # x
      {121, '-.--'},  # y
      {122, '--..'}   # z
    ]
  end

  # --------------------------- Encoding ---------------------------

  @doc """
  Transforms the Morse code tree into a map for efficient encoding.

  The `tree_to_map/3` function is a recursive function that traverses the Morse code tree and builds a map where each character is mapped to its corresponding Morse code.

  It takes three arguments:

  1. The current node in the Morse code tree, which is a tuple `{:node, char, left, right}` or `:nil`.
  2. The current Morse code prefix, a list of short (dot) and long (dash) signals accumulated so far.
  3. The map that is being built during the traversal.

  The function processes the Morse code tree as follows:

  1. If the current node is `:nil`, it means we have reached a leaf node or an empty subtree, and the function simply returns the current map without any modifications.
  2. If the current node has a character other than `:na`, it means we have found a valid Morse code for the character. The function updates the map by associating the character with its Morse code (the current prefix), and then continues the traversal for both the left and the right subtrees. The Morse code prefix for the left subtree is extended with a dot, while the prefix for the right subtree is extended with a dash.
  3. If the current node has a character `:na`, it means
  """
  defp tree_to_map(tree, current_path, morse_map) do
    case tree do
      :nil -> morse_map
      {:node, :na, left, right} ->
        morse_map
        |> tree_to_map(left, current_path <> "0", morse_map)
        |> tree_to_map(right, current_path <> "1", morse_map)
      {:node, value, left, right} ->
        new_map = Map.put(morse_map, value, current_path)
        |> tree_to_map(left, current_path <> "0", morse_map)
        |> tree_to_map(right, current_path <> "1", morse_map)
    end
  end

  @doc """
  Constructs the encoding table from the Morse code tree.
  The encoding table is represented as a map, providing O(1) lookup for Morse codes
  corresponding to each character. The table construction complexity is O(k) where
  k is the number of characters in the alphabet.
  """
  def encoding_table() do
    tree_to_map(morse(), "", %{})
  end

  @doc """
  Encodes a charlist into a Morse code using the provided encoding_table.
  This is a tail recursive helper function with a complexity of O(n * m), where n is
  the length of the message and m is the length of the Morse codes.
  """
  defp encode_charlist([], _encoding_table, result) do result end
  defp encode_charlist([char | rest], encoding_table, result) do
    morse_code = Map.get(encoding_table, char)
    updated_result = result <> morse_code <> ' '
    encode_charlist(rest, encoding_table, updated_result)
  end

  @doc """
  Encodes a message into Morse code. Handles both '' and "" input.
  The encoding process has a complexity of O(n * m), where n is the length of
  the message and m is the length of the Morse codes.
  """
  def encode(message) when is_binary(message) do
    encode_message(String.to_charlist(message))
  end
  def encode(message) when is_list(message) do
    encoding_table = encoding_table()
    encoded = encode_charlist(message, encoding_table, [])
    Enum.join(encoded, ' ')
  end


  # --------------------------- Decoding ---------------------------


  @doc """
  Decodes a specified morse code sequence.
  The encoding process has a complexity of O(n * m), where n is the length of
  the message and m is the length of the Morse codes.
  """
  def decode(morse_message) do
    morse_codes = String.split(Enum.join(morse_message, ''), " ")
    decoded_chars = Enum.map(morse_codes, &decode_morse_code/1)
    Enum.join(decoded_chars, '')
  end

  @doc """
  Decodes a Morse code into a character using the Morse code tree.
  The decoding process has a complexity of O(m), where m is the length of the Morse code,
  taking advantage of the fact that frequently occurring characters have shorter codes.
  """
  def decode_morse_code(morse_code) do
    morse_tree = morse()
    decode_morse_code_helper(morse_code, morse_tree)
  end

  @doc """
  A helper function for decode_morse_code/1 that traverses the Morse code tree.
  It recursively traverses the tree based on the input Morse code list, with a
  complexity of O(m), where m is the length of the Morse code.
  """
  defp decode_morse_code_helper([], {:node, char, _left, _right}) do
    char
  end
  defp decode_morse_code_helper([?. | rest], {:node, _char, left, _right}) do
    decode_morse_code_helper(rest, left)
  end
  defp decode_morse_code_helper([?- | rest], {:node, _char, _left, right}) do
    decode_morse_code_helper(rest, right)
  end

end
