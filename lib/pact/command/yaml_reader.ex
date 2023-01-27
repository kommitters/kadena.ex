defmodule Kadena.Pact.Command.YamlReader do
  @moduledoc """
  Reads YAML file to create a command.
  """

  @type path :: String.t()
  @type root_path :: String.t()
  @type map_result :: map()
  @type processed_map :: {:ok, map_result()} | {:error, Keyword.t() | struct()}

  @spec read(path :: path()) :: processed_map()
  def read(path) do
    root_path = Path.dirname(path)

    with {:ok, map_result} <- YamlElixir.read_from_file(path),
         {:ok, map_result} <- process_code(map_result, root_path) do
      process_data(map_result, root_path)
    end
  end

  @spec process_code(map_result :: map_result(), root_path :: root_path()) :: processed_map()
  defp process_code(%{"codeFile" => code_file} = map_result, root_path)
       when is_binary(code_file) do
    case String.match?(code_file, ~r{^.*\.(pact)$}) do
      true ->
        map_result
        |> Map.put("code", File.read!(root_path <> "/#{code_file}"))
        |> Map.delete("codeFile")
        |> (&{:ok, &1}).()

      false ->
        {:error, [code_file: :not_a_pact_file]}
    end
  end

  defp process_code(%{"codeFile" => nil} = map_result, _root_path),
    do: {:ok, Map.delete(map_result, "codeFile")}

  defp process_code(%{"code" => code} = map_result, _root_path) when is_binary(code),
    do: {:ok, map_result}

  defp process_code(%{"code" => nil} = map_result, _root_path),
    do: {:ok, Map.delete(map_result, "code")}

  defp process_code(map_result, _root_path), do: {:ok, map_result}

  @spec process_data(map_result :: map_result(), root_path :: root_path()) :: processed_map()
  defp process_data(%{"dataFile" => data_file} = yaml, root_path) when is_binary(data_file) do
    case String.match?(data_file, ~r{^.*\.(json)$}) do
      true ->
        (root_path <> "/#{data_file}")
        |> File.read!()
        |> Jason.decode!()
        |> (&Map.put(yaml, "data", &1)).()
        |> Map.delete("dataFile")
        |> (&{:ok, &1}).()

      false ->
        {:error, [data_file: :not_a_json_file]}
    end
  end

  defp process_data(%{"dataFile" => nil} = map_result, _root_path),
    do: {:ok, Map.delete(map_result, "dataFile")}

  defp process_data(%{"data" => %{}} = map_result, _root_path), do: {:ok, map_result}

  defp process_data(%{"data" => nil} = map_result, _root_path),
    do: {:ok, Map.delete(map_result, "data")}

  defp process_data(map_result, _root_path), do: {:ok, map_result}
end
