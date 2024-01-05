defmodule JsonParser.MixProject do
  use Mix.Project

  def project do
    [
      app: :json_parser,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7.2"}
    ]
  end

  defp escript do
    [main_module: JsonParser]
  end
end
