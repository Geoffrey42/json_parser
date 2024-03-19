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
    {key, next_tokens} = pop_key(tokens)

    {value, next_tokens_again} = pop_value(next_tokens)

    updated_ast = put_in(ast, [:object, key], value)

    case List.first(next_tokens_again) do
      {:delimiter, :right_brace} ->
        {updated_ast, next_tokens_again}

      {:delimiter, :comma} ->
        object(move_forward(next_tokens_again), updated_ast)
    end
  end

  defp pop_key([{:string, key} | remaining_tokens]), do: {key, move_forward(remaining_tokens)}

  defp pop_value([{:string, value} | remaining_tokens]),
    do: {value, remaining_tokens}

  defp pop_value([{:boolean, value} | remaining_tokens]),
    do: {value, remaining_tokens}

  defp pop_value([{:number, value} | remaining_tokens]),
    do: {value, remaining_tokens}

  defp pop_value([:null | remaining_tokens]), do: {nil, remaining_tokens}

  defp pop_value([{:delimiter, :left_brace} | remaining_tokens]) do
    object(remaining_tokens, %{object: %{}})
  end

  defp move_forward(tokens), do: Enum.drop(tokens, 1)
end
