defmodule Parser do
  @moduledoc """
  Parses the tokens to build an AST.
  """

  @spec parse(list(Entity.token())) :: {:ok, map()}
  def parse([{:delimiter, :left_brace}, {:delimiter, :right_brace}]) do
    {:ok, {:object, %{}}}
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

  @spec object(list(Entity.token()), map()) :: {map(), list(Entity.token())}
  defp object([], ast), do: {ast, []}

  defp object(tokens, ast) do
    {key, next_tokens} = pop_tokens(tokens, 2)

    {value, next_tokens_again} = pop_tokens(next_tokens, 1)

    updated_ast = put_in(ast, [:object, key], value)

    case List.first(next_tokens_again) do
      {:delimiter, :right_brace} -> {updated_ast, next_tokens_again}
      {:delimiter, :comma} -> object(move_forward(next_tokens_again), updated_ast)
      {:delimiter, :right_bracket} -> object(skip_delimiters(next_tokens_again), updated_ast)
      nil -> {updated_ast, []}
    end
  end

  @spec array(list(Entity.token()), map()) :: {map(), list(Entity.token())}
  defp array([], ast), do: {sort(ast), []}

  defp array(tokens, ast) do
    {value, next_tokens} = pop_tokens(tokens, 1)

    updated_ast = put_in(ast, [:array], [value | ast.array])

    case List.first(next_tokens) do
      {:delimiter, :right_bracket} -> {sort(updated_ast), next_tokens}
      {:delimiter, :comma} -> array(move_forward(next_tokens), updated_ast)
      {:delimiter, :right_brace} -> array(skip_delimiters(next_tokens), updated_ast)
    end
  end

  defp pop_tokens(
         [{:delimiter, :left_brace} | [{:delimiter, :right_brace} | remaining_tokens]],
         _times
       ) do
    {%{object: %{}}, remaining_tokens}
  end

  defp pop_tokens([{:delimiter, :left_brace} | remaining_tokens], _times) do
    object(remaining_tokens, %{object: %{}})
  end

  defp pop_tokens(
         [{:delimiter, :left_bracket} | [{:delimiter, :right_bracket} | remaining_tokens]],
         _times
       ) do
    {%{array: []}, remaining_tokens}
  end

  defp pop_tokens([{:delimiter, :left_bracket} | remaining_tokens], _times) do
    array(remaining_tokens, %{array: []})
  end

  defp pop_tokens([:null | remaining_tokens], _times), do: {nil, remaining_tokens}

  @value_tokens [:number, :string, :boolean]
  defp pop_tokens([{type, value} | _remaining_tokens] = tokens, times)
       when is_atom(type) and type in @value_tokens do
    {value, move_forward(tokens, times)}
  end

  defp move_forward(tokens, nb \\ 1), do: Enum.drop(tokens, nb)

  defp skip_delimiters([]), do: []

  @delimiter_tokens [:right_brace, :right_bracket]
  defp skip_delimiters([{:delimiter, value} | remaining_tokens])
       when value in @delimiter_tokens do
    skip_delimiters(remaining_tokens)
  end

  defp skip_delimiters([{type, _value} | _remaining_tokens] = tokens)
       when type in @value_tokens do
    tokens
  end

  defp sort(%{array: elements} = ast) do
    %{ast | array: Enum.reverse(elements)}
  end
end
