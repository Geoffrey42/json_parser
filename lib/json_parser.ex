defmodule JsonParser do
  @moduledoc """
  Documentation for `JsonParser`.
  """

  def main(args) when length(args) > 1 do
    IO.puts(:stderr, "error: must have only one argument.")
  end

  def main(args) do
    file_name = List.first(args)

    case File.read(file_name) do
      {:ok, text} ->
        tokens = Lexer.lex(text)

        case Parser.parse(tokens) do
          {:ok, _ast} -> exit(:normal)
        end

      {:error, reason} ->
        IO.puts(:stderr, "error: could not read #{file_name} : #{:file.format_error(reason)}")
    end
  end
end
