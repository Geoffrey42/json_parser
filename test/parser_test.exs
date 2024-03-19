defmodule ParserTest do
  use ExUnit.Case, async: true

  test "should build AST for empty JSON object {}" do
    assert {:ok, {:object, %{}}} =
             Parser.parse([{:delimiter, :left_brace}, {:delimiter, :right_brace}])
  end

  test "should return an error for an invalid JSON (empty text)" do
    assert {:error, :invalid_json} = Parser.parse([])
  end

  test "should build AST for object containing various type values" do
    tokens = [
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
      {:string, "key6"},
      {:delimiter, :colon},
      {:delimiter, :left_bracket},
      {:number, 42},
      {:delimiter, :comma},
      {:string, "forty-two"},
      {:delimiter, :comma},
      {:delimiter, :left_brace},
      {:string, "subkey1"},
      {:delimiter, :colon},
      {:boolean, true},
      {:delimiter, :right_brace},
      {:delimiter, :right_bracket},
      {:delimiter, :right_brace}
    ]

    assert {:ok,
            %{
              object: %{
                "key1" => true,
                "key2" => false,
                "key3" => nil,
                "key4" => "value",
                "key5" => 101,
                "key6" => %{array: [42, "forty-two", %{object: %{"subkey1" => true}}]}
              }
            }} = Parser.parse(tokens)
  end
end
