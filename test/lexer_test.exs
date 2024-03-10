defmodule LexerTest do
  use ExUnit.Case, async: true

  test "should build tokens for empty JSON object {}" do
    tokens = Lexer.lex("{}")

    assert tokens == [:left_brace, :right_brace]
  end

  test "should build tokens for simple JSON object" do
    tokens = Lexer.lex("{\"key\": \"value\"}")

    assert tokens == [
             :left_brace,
             {:string, "key"},
             :colon,
             {:string, "value"},
             :right_brace
           ]
  end

  test "should build tokens for object containing various type values" do
    tokens = Lexer.lex("{
      \"key1\": true,
      \"key2\": false,
      \"key3\": null,
      \"key4\": \"value\",
      \"key5\": 101
    }")

    assert tokens == [
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
  end
end
