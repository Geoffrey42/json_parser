defmodule Lexer do
  @moduledoc """
  Build a list of tokens from the text input.
  """

  @doc """
  lex builds a list of tokens from a text input.
  """

  @spec lex(binary()) :: list(Entity.token()) | nil
  @spec lex(binary() | <<>>, list(Entity.token())) :: list(Entity.token()) | nil
  def lex(text, tokens \\ [])

  def lex(<<>>, tokens), do: Enum.reverse(tokens)

  def lex(<<?{, rest::binary>>, tokens) do
    lex(rest, [{:delimiter, :left_brace} | tokens])
  end

  def lex(<<?}, rest::binary>>, tokens) do
    lex(rest, [{:delimiter, :right_brace} | tokens])
  end

  def lex(<<?[, rest::binary>>, tokens) do
    lex(rest, [{:delimiter, :left_bracket} | tokens])
  end

  def lex(<<?], rest::binary>>, tokens) do
    lex(rest, [{:delimiter, :right_bracket} | tokens])
  end

  def lex(<<?:, rest::binary>>, tokens) do
    lex(rest, [{:delimiter, :colon} | tokens])
  end

  def lex(<<?,, rest::binary>>, tokens) do
    lex(rest, [{:delimiter, :comma} | tokens])
  end

  def lex(<<?t, rest::binary>>, tokens) do
    scan_boolean(rest, true, tokens)
  end

  def lex(<<?f, rest::binary>>, tokens) do
    scan_boolean(rest, false, tokens)
  end

  def lex(<<?n, rest::binary>>, tokens) do
    scan_null(rest, tokens)
  end

  def lex(<<?", rest::binary>>, tokens) do
    {string_content, new_rest} = scan_string(rest)
    lex(new_rest, [{:string, string_content} | tokens])
  end

  def lex(<<?\s, rest::binary>>, tokens) do
    lex(rest, tokens)
  end

  def lex(<<?\n, rest::binary>>, tokens) do
    lex(rest, tokens)
  end

  def lex(<<nb, rest::binary>>, tokens) when is_number(nb) do
    {number_content, new_rest} = scan_number(nb, rest)
    lex(new_rest, [{:number, number_content} | tokens])
  end

  defp scan_boolean(text, mode, tokens) do
    remaining_char =
      case mode do
        true -> "rue"
        false -> "alse"
      end

    if String.starts_with?(text, remaining_char) do
      new_rest =
        text
        |> String.codepoints()
        |> Enum.drop(String.length(remaining_char))
        |> Enum.join()

      lex(new_rest, [{:boolean, mode} | tokens])
    end
  end

  defp scan_null(text, tokens) do
    if String.starts_with?(text, "ull") do
      new_rest =
        text
        |> String.codepoints()
        |> Enum.drop(String.length("ull"))
        |> Enum.join()

      lex(new_rest, [:null | tokens])
    end
  end

  defp scan_string(text) do
    {string_content_array, rest_array} =
      text
      |> String.codepoints()
      |> Enum.split_while(fn char -> char != "\"" end)

    {_removed, rest_without_starting_quote} = List.pop_at(rest_array, 0)
    rest = Enum.join(rest_without_starting_quote)

    string_content = Enum.join(string_content_array)
    {string_content, rest}
  end

  defp scan_number(first_number, text) do
    {remaining_numbers_array, rest_array} =
      text
      |> String.codepoints()
      |> Enum.split_while(fn char -> char >= "0" and char <= "9" end)

    rest = Enum.join(rest_array)

    remaining_numbers = Enum.join(remaining_numbers_array)
    number = String.to_integer(to_string([first_number]) <> remaining_numbers)

    {number, rest}
  end
end
