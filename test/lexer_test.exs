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
end
