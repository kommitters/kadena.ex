defmodule Kadena.Types.ExecPayload do
  @moduledoc """
  `ExecPayload` struct definition.
  """

  alias Kadena.Types.{EnvData, PactCode}

  @behaviour Kadena.Types.Spec

  @type data :: EnvData.t() | nil
  @type code :: PactCode.t()
  @type validation :: {:ok, any()} | {:error, atom()}
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

  @spec validate_data(data :: data()) :: validation()
  defp validate_data(%EnvData{} = data), do: {:ok, data}
  defp validate_data(_data), do: {:error, :invalid_data}

  @spec validate_code(code :: code()) :: validation()
  defp validate_code(%PactCode{} = code), do: {:ok, code}
  defp validate_code(_code), do: {:error, :invalid_code}
end
