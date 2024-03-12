defmodule Entity do
  @moduledoc """
  Entities used throughout the JSON parser.
  """

  @typedoc """
  A lexical token is a term with an assigned and thus identified meaning.
  """
  @type token ::
          {:delimiter, :left_brace}
          | {:delimiter, :right_brace}
          | {:delimiter, :colon}
          | {:delimiter, :comma}
          | {:delimiter, :left_bracket}
          | {:delimiter, :right_bracket}
          | {:string, binary()}
          | {:boolean, boolean()}
          | {:number, integer()}
          | :null

  @typedoc """
  Abstract Syntax Tree (AST) representing the structure of the given JSON.
  """
  @type ast :: {:object, list()}
end
