defmodule Parser do
  @moduledoc """
  Parses the tokens to build an AST of 2-tuples nodes and leaves.
  """

  # need to store state in an agent. Here
  # state is the lookahead, the next token for my LL(2) parser
  # parse will init the agent and start enumerate on the tokens
  # a match private function will be used for terminal tokens
  # a consume private function will be called by match to update the lookahead
  # match will be called by non terminal functions that either call match or call another non terminal function. 

  @spec parse(list(Entity.token())) :: {:ok, Entity.ast()} | {:error, :atom}
  def parse([:left_brace, :right_brace]) do
    {:ok, {:object, []}}
  end

  def parse([]), do: {:error, :invalid_json}

  def parse(tokens) do
    ast =
      case List.first(tokens) do
        :left_brace ->
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

    updated_ast = put_elem(ast, 1, [{key, value}])

    case move_forward(next_tokens) |> hd do
      :right_brace ->
        updated_ast

      :comma ->
        object(move_forward(tokens), updated_ast)
    end
  end

  defp get_key({:string, key}), do: key

  defp get_value({:string, value}), do: value

  defp move_forward(tokens), do: Enum.drop(tokens, 1)
end
