defmodule Kadena.Types.ExecPayload do
  @moduledoc """
  `ExecPayload` struct definition.
  """

  alias Kadena.Types.{EnvData, PactCode}

  @behaviour Kadena.Types.Spec

  @type data :: EnvData.t() | nil
  @type code :: PactCode.t()
  @type value :: data() | code()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}
  @type t :: %__MODULE__{
          data: data(),
          code: code()
        }

  defstruct [:data, :code]

  @impl true
  def new(args) do
    data = Keyword.get(args, :data)
    code = Keyword.get(args, :code)

    with {:ok, data} <- validate_data(data),
         {:ok, code} <- validate_code(code) do
      %__MODULE__{data: data, code: code}
    end
  end

  @spec validate_data(data :: map()) :: validation()
  defp validate_data(data) when is_map(data), do: {:ok, EnvData.new(data)}
  defp validate_data(nil), do: {:ok, nil}
  defp validate_data(_data), do: {:error, [data: :invalid]}

  @spec validate_code(code :: String.t()) :: validation()
  defp validate_code(code) when is_binary(code), do: {:ok, PactCode.new(code)}
  defp validate_code(_code), do: {:error, [code: :invalid]}
end
