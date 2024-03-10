defmodule ParserTest do
  use ExUnit.Case, async: true

  test "should build AST for empty JSON object {}" do
    assert {:ok, {:object, []}} = Parser.parse([:left_brace, :right_brace])
  end

  test "should return an error for an invalid JSON (empty text)" do
    assert {:error, :invalid_json} = Parser.parse([])
  end

  test "should build AST for object containing various type values" do
    tokens = [
      :left_brace,
      {:string, "key1"},
      :colon,
      {:boolean, true},
      :comma,
      {:string, "key2"},
      :colon,
      {:boolean, false},
      :comma,
      {:string, "key3"},
      :colon,
      :null,
      :comma,
      {:string, "key4"},
      :colon,
      {:string, "value"},
      :comma,
      {:string, "key5"},
      :colon,
      {:number, 101},
      :right_brace
    ]

    assert {:ok,
            {:object,
             [
               {"key1", true},
               {"key2", false},
               {"key3", nil},
               {"key4", "value"},
               {"key5", 101}
             ]}} = Parser.parse(tokens)
  end
end
