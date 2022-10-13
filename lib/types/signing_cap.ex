defmodule Kadena.Types.SigningCap do
  @moduledoc """
  `SigningCap` struct definition.
  """

  alias Kadena.Types.Cap

  @behaviour Kadena.Types.Spec

  @type str :: String.t()
  @type role :: str()
  @type description :: str()
  @type cap :: Cap.t()
  @type value :: str() | cap()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{role: role(), description: description(), cap: cap()}

  defstruct [:role, :description, :cap]

  @impl true
  def new(args) when is_list(args) do
    role = Keyword.get(args, :role)
    description = Keyword.get(args, :description)
    cap = Keyword.get(args, :cap)

    with {:ok, role} <- validate_str(:role, role),
         {:ok, description} <- validate_str(:description, description),
         {:ok, cap} <- validate_cap(cap) do
      %__MODULE__{role: role, description: description, cap: cap}
    end
  end

  def new(_args), do: {:error, [signing_cap: :not_a_list]}

  @spec validate_str(field :: atom(), value :: str()) :: validation()
  defp validate_str(_field, value) when is_binary(value), do: {:ok, value}
  defp validate_str(field, _value), do: {:error, [{field, :invalid}]}

  @spec validate_cap(cap :: cap()) :: validation()
  defp validate_cap(%Cap{} = cap), do: {:ok, cap}

  defp validate_cap(cap) do
    case Cap.new(cap) do
      %Cap{} = cap -> {:ok, cap}
      {:error, reasons} -> {:error, [cap: :invalid] ++ reasons}
    end
  end
end
