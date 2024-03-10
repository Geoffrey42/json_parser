defmodule Entity do
  @moduledoc """
  Entities used throughout the JSON parser.
  """

  @typedoc """
  A lexical token is a term with an assigned and thus identified meaning.
  """
  @type token ::
          :left_brace
          | :right_brace
          | :colon
          | :comma
          | {:string, binary()}
          | {:boolean, boolean()}
          | {:number, integer()}

  @typedoc """
  Abstract Syntax Tree (AST) representing the structure of the given JSON.
  """
  @type ast :: {:object, list()}
end
