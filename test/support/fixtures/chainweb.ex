defmodule Kadena.Test.Fixtures.Chainweb do
  @moduledoc """
  Mocks Chainweb API responses.
  """

  @type fixture :: String.t() | atom()

  @fixtures_path "./test/support/fixtures/chainweb/"

  @spec fixture(fixture :: fixture()) :: binary()
  def fixture(fixture_name, opts \\ []) do
    raw = Keyword.get(opts, :raw_data, false)

    body =
      fixture_name
      |> to_string()
      |> read_json_file()

    if(raw, do: body, else: Jason.decode!(body, keys: &snake_case_atom/1))
  end

  @spec read_json_file(filename :: String.t()) :: binary()
  defp read_json_file(filename) do
    file = Path.expand(@fixtures_path <> "#{filename}.json")
    with {:ok, body} <- File.read(file), do: body
  end

  @spec snake_case_atom(string :: String.t()) :: atom()
  defp snake_case_atom(string) do
    string
    |> Macro.underscore()
    |> String.to_atom()
  end
end
