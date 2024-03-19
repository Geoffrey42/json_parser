defmodule Parser do
  @moduledoc """
  Parses the tokens to build an AST of 2-tuples nodes and leaves.
  """

  @spec parse(list(Entity.token())) :: {:ok, Entity.ast()}
  def parse([{:delimiter, :left_brace}, {:delimiter, :right_brace}]) do
    {:ok, {:object, []}}
  end

  def parse([]), do: {:error, :invalid_json}

  def parse(tokens) do
    ast =
      case List.first(tokens) do
        {:delimiter, :left_brace} ->
          {ast, _last_tokens} = object(Enum.drop(tokens, 1), %{object: %{}})
          ast
      end

    {:ok, ast}
  end

  defp object(tokens, ast) do
    {key, next_tokens} = pop_tokens(tokens, 2)

    {value, next_tokens_again} = pop_tokens(next_tokens, 1)

    updated_ast = put_in(ast, [:object, key], value)

    case List.first(next_tokens_again) do
      {:delimiter, :right_brace} ->
        {updated_ast, next_tokens_again}

      {:delimiter, :comma} ->
        object(move_forward(next_tokens_again), updated_ast)
    end
  end

  defp pop_tokens([{:delimiter, :left_brace} | remaining_tokens], _times) do
    object(remaining_tokens, %{object: %{}})
  end

  defp pop_tokens([:null | remaining_tokens], _times), do: {nil, remaining_tokens}

  defp pop_tokens([{type, value} | _remaining_tokens] = tokens, times) when is_atom(type) do
    {value, move_forward(tokens, times)}
  end

  defp move_forward(tokens, nb \\ 1), do: Enum.drop(tokens, nb)
end
