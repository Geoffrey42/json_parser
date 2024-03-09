defmodule ParserTest do
  use ExUnit.Case, async: true

  test "should build AST for empty JSON object {}" do
    assert {:ok, {:object, []}} = Parser.parse([:left_brace, :right_brace])
  end

  test "should return an error for an invalid JSON (empty text)" do
    assert {:error, :invalid_json} = Parser.parse([])
  end

  test "should build AST for simple JSON object" do
    tokens = [
      :left_brace,
      {:string, "key"},
      :colon,
      {:string, "value"},
      :right_brace
    ]

    assert {:ok, {:object, [{"key", "value"}]}} = Parser.parse(tokens)
  end
end
