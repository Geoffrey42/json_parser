defmodule Lexer do
  @moduledoc """
  Build a list of tokens from the text input.
  """

  @doc """
  lex builds a list of tokens from a text input.
  """

  @spec lex(binary(), list(Entity.token())) :: list(Entity.token())
  def lex(text, tokens \\ [])

  def lex(<<>>, tokens), do: Enum.reverse(tokens)

  def lex(<<char, rest::binary>>, tokens) do
    case char do
      ?{ ->
        lex(rest, [:left_brace | tokens])

      ?} ->
        lex(rest, [:right_brace | tokens])

      ?: ->
        lex(rest, [:colon | tokens])

      ?" ->
        {string_content, new_rest} = scan_string(rest)
        lex(new_rest, [{:string, string_content} | tokens])

      ?\s ->
        lex(rest, tokens)
    end
  end

  defp scan_string(text) do
    {string_content_array, rest_array} =
      text
      |> String.codepoints()
      |> Enum.split_while(fn char -> char != "\"" end)

    {_removed, rest_without_starting_quote} = List.pop_at(rest_array, 0)
    string_content = Enum.join(string_content_array)
    rest = Enum.join(rest_without_starting_quote)

    {string_content, rest}
  end
end
