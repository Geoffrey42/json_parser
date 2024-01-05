defmodule ParserTest do
  use ExUnit.Case, async: true

  test "should build AST for empty JSON object {}" do
    assert {:ok, {:object, []}} = Parser.parse([:left_brace, :right_brace])
  end

  test "should return an error for an invalid JSON (empty text)" do
    assert {:error, :invalid_json} = Parser.parse([])
  end
end
