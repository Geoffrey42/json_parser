defmodule LexerTest do
  use ExUnit.Case, async: true

  test "should build tokens for empty JSON object {}" do
    tokens = Lexer.lex("{}")

    assert tokens == [:left_brace, :right_brace]
  end
end
