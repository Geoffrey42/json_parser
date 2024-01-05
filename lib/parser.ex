defmodule Parser do
  @moduledoc """
  Parses the tokens to build an AST of 2-tuples nodes and leaves.
  """

  def parse([:left_brace, :right_brace]) do
    {:ok, {:object, []}}
  end

  def parse([]), do: {:error, :invalid_json}
end
