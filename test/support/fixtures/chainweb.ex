defmodule Kadena.Test.Fixtures.Chainweb do
  @moduledoc """
  Mocks Chainweb API responses.
  """

  @type fixture :: String.t() | atom()

  @fixtures_path "./test/support/fixtures/chainweb/"

  @spec fixture(fixture :: fixture()) :: binary()
  def fixture(fixture_name) do
    fixture_name
    |> to_string()
    |> read_json_file()
  end

  @spec read_json_file(filename :: String.t()) :: binary()
  defp read_json_file(filename) do
    file = Path.expand(@fixtures_path <> "#{filename}.json")
    with {:ok, body} <- File.read(file), do: body
  end
end
