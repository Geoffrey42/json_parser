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
          object(Enum.drop(tokens, 1), {:object, []})
      end

    {:ok, ast}
  end

  defp object(tokens, ast) do
    key = get_key(List.first(tokens))

    next_tokens =
      tokens
      |> move_forward()
      |> move_forward()

    value = get_value(List.first(next_tokens))

    updated_ast = update_object(ast, key, value)

    next_tokens = move_forward(next_tokens)

    case List.first(next_tokens) do
      {:delimiter, :right_brace} ->
        sort_object_pairs(updated_ast)

      {:delimiter, :comma} ->
        object(move_forward(next_tokens), updated_ast)
    end
  end

  defp get_key({:string, key}), do: key

  defp get_value({:string, value}), do: value

  defp get_value({:boolean, value}), do: value

  defp get_value({:number, value}), do: value

  defp get_value(:null), do: nil

  defp move_forward(tokens), do: Enum.drop(tokens, 1)

  defp update_object(ast, key, value) do
    existing_pairs = elem(ast, 1)

    {:object, [{key, value} | existing_pairs]}
  end

  defp sort_object_pairs(ast) do
    sorted_pairs =
      elem(ast, 1)
      |> Enum.reverse()

    {:object, sorted_pairs}
  end
end
