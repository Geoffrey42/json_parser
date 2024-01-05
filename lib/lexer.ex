defmodule Lexer do
  @moduledoc """
  Build a list of tokens from the input text.
  """

  def lex(text) do
    String.codepoints(text) |> Enum.map(fn character -> scan(character) end)
  end

  defp scan("{"), do: :left_brace
  defp scan("}"), do: :right_brace
end
