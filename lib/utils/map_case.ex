defmodule Kadena.Utils.MapCase do
  @moduledoc """
  `Utils.MapCase` functions to convert the keys of a map to camel or snake case
  """

  @type key :: atom() | String.t()
  @type opt :: :to_camel | :to_snake
  @type str :: String.t()
  @type value :: any()
  @type words :: list(str)

  @spec to_camel(map :: map()) :: {:ok, map()}
  def to_camel(map) when is_map(map), do: {:ok, format(map, :to_camel)}

  @spec to_camel!(map :: map()) :: map()
  def to_camel!(map) when is_map(map), do: format(map, :to_camel)

  @spec to_snake(map :: map()) :: {:ok, map()}
  def to_snake(map) when is_map(map), do: {:ok, format(map, :to_snake)}

  @spec to_snake!(map :: map()) :: map()
  def to_snake!(map) when is_map(map), do: format(map, :to_snake)

  @spec format(map :: map(), type :: opt()) :: map()
  defp format(%Decimal{} = decimal, _type), do: decimal

  defp format(%{} = map, type) do
    map
    |> Enum.map(fn {k, v} -> {format_key(k, type), format_value(v, type)} end)
    |> Enum.into(%{})
  end

  defp format(value, _type), do: value

  @spec format_key(key :: key(), type :: opt()) :: str()
  defp format_key(key, type) when is_atom(key),
    do: key |> Atom.to_string() |> format_key(type)

  defp format_key(key, :to_camel) when is_binary(key) do
    if String.contains?(key, "_") do
      [first_word | rest] = String.split(key, "_")
      first_word <> camelize(rest)
    else
      key
    end
  end

  defp format_key(key, :to_snake) when is_binary(key), do: Macro.underscore(key)

  @spec format_value(value :: value(), type :: opt()) :: str() | map()
  defp format_value(value, type) when is_map(value), do: format(value, type)

  defp format_value(value, type) when is_list(value),
    do: Enum.map(value, fn map -> format(map, type) end)

  defp format_value(value, _type), do: value

  @spec camelize(words :: words()) :: str()
  defp camelize([]), do: ""
  defp camelize([word | rest]), do: Macro.camelize(word) <> camelize(rest)
end
