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
  defp validate_data(nil), do: {:ok, nil}
  defp validate_data(%EnvData{} = data), do: {:ok, data}

  defp validate_data(data) do
    case EnvData.new(data) do
      %EnvData{} = data -> {:ok, data}
      _error -> {:error, [data: :invalid]}
    end
  end

  @spec validate_code(code :: String.t()) :: validation()
  defp validate_code(code) do
    case PactCode.new(code) do
      %PactCode{} = code -> {:ok, code}
      _error -> {:error, [code: :invalid]}
    end
  end
end
