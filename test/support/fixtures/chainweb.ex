defmodule Kadena.Test.Fixtures.Chainweb do
  @moduledoc """
  Mocks Chainweb API responses.
  """

  alias Kadena.Utils.MapCase

  @type fixture :: String.t() | atom()
  @type opts :: Keyword.t()

  @fixtures_path "./test/support/fixtures/chainweb/"

  @spec fixture(fixture :: fixture(), opts :: opts()) :: binary()
  def fixture(fixture_name, opts \\ []) do
    to_snake = Keyword.get(opts, :to_snake, false)

    fixture_name
    |> to_string()
    |> read_json_file()
    |> parse_to_snake(to_snake)
  end

  @spec read_json_file(filename :: String.t()) :: binary()
  defp read_json_file(filename) do
    file = Path.expand(@fixtures_path <> "#{filename}.json")
    with {:ok, body} <- File.read(file), do: body
  end

  @spec parse_to_snake(body :: binary(), to_snake :: boolean()) :: map() | binary()
  defp parse_to_snake(body, true), do: body |> Jason.decode!() |> MapCase.to_snake!()
  defp parse_to_snake(body, false), do: body
end
