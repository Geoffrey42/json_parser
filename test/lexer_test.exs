defmodule LexerTest do
  use ExUnit.Case, async: true

  test "should build tokens for empty JSON object {}" do
    tokens = Lexer.lex("{}")

    assert tokens == [{:delimiter, :left_brace}, {:delimiter, :right_brace}]
  end

  test "should build tokens for object containing various type values" do
    tokens = Lexer.lex("{
      \"key1\": true,
      \"key2\": false,
      \"key3\": null,
      \"key4\": \"value\",
      \"key5\": 101,
      \"key-o\": {\"subkey\": \"subvalue\"},
      \"key-l\": [\"1\", 2]
    }")

    assert tokens == [
             {:delimiter, :left_brace},
             {:string, "key1"},
             {:delimiter, :colon},
             {:boolean, true},
             {:delimiter, :comma},
             {:string, "key2"},
             {:delimiter, :colon},
             {:boolean, false},
             {:delimiter, :comma},
             {:string, "key3"},
             {:delimiter, :colon},
             :null,
             {:delimiter, :comma},
             {:string, "key4"},
             {:delimiter, :colon},
             {:string, "value"},
             {:delimiter, :comma},
             {:string, "key5"},
             {:delimiter, :colon},
             {:number, 101},
             {:delimiter, :comma},
             {:string, "key-o"},
             {:delimiter, :colon},
             {:delimiter, :left_brace},
             {:string, "subkey"},
             {:delimiter, :colon},
             {:string, "subvalue"},
             {:delimiter, :right_brace},
             {:delimiter, :comma},
             {:string, "key-l"},
             {:delimiter, :colon},
             {:delimiter, :left_bracket},
             {:string, "1"},
             {:delimiter, :comma},
             {:number, 2},
             {:delimiter, :right_bracket},
             {:delimiter, :right_brace}
           ]
  end
end
