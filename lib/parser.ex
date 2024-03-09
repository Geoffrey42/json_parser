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

  def parse([:left_brace, {:string, key}, :colon, {:string, value}, :right_brace]) do
    {:ok, {:object, [{key, value}]}}
  end

  def parse([]), do: {:error, :invalid_json}
end
