defmodule ParserTest do
  use ExUnit.Case, async: true

  test "should build AST for empty JSON object {}" do
    ast = Parser.parse([:left_brace, :right_brace])

    assert ast == {:object, []}
  end
end
