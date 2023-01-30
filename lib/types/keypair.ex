defmodule Kadena.Types.KeyPair do
  @moduledoc """
  `KeyPair` struct definition.
  """
  alias Kadena.Types.Cap

  @behaviour Kadena.Types.Spec

  @type key :: String.t()
  @type clist :: list(Cap.t()) | nil
  @type arg_type :: atom()
  @type arg_value :: key() | clist()
  @type arg :: {arg_type(), arg_value()}
  @type arg_validation :: {:ok, arg_value()} | {:error, Keyword.t()}
  @type validated_keypair :: t() | {:error, Keyword.t()}

  @type t :: %__MODULE__{pub_key: key(), secret_key: key(), clist: clist()}

  defstruct [:pub_key, :secret_key, :clist]

  @impl true
  def new(args) when is_list(args) do
    pub_key_arg = Keyword.get(args, :pub_key)
    secret_key_arg = Keyword.get(args, :secret_key)
    clist_arg = Keyword.get(args, :clist)

    with {:ok, pub_key} <- validate_key({:pub_key, pub_key_arg}),
         {:ok, secret_key} <- validate_key({:secret_key, secret_key_arg}),
         {:ok, clist} <- validate_caps_list({:clist, clist_arg}) do
      %__MODULE__{pub_key: pub_key, secret_key: secret_key, clist: clist}
    end
  end

  def new(args) when is_map(args) do
    pub_key_arg = Map.get(args, "public")
    secret_key_arg = Map.get(args, "secret")
    clist_arg = Map.get(args, "capsList")

    with {:ok, pub_key} <- validate_key({:pub_key, pub_key_arg}),
         {:ok, secret_key} <- validate_key({:secret_key, secret_key_arg}),
         {:ok, clist} <- create_clist({:clist, clist_arg}) do
      %__MODULE__{pub_key: pub_key, secret_key: secret_key, clist: clist}
    end
  end

  def new(_args), do: {:error, [args: :not_a_list]}

  @spec add_caps(keypair :: t(), caps :: clist()) :: validated_keypair()
  def add_caps(%__MODULE__{} = keypair, caps) do
    case validate_caps_list({:clist, caps}) do
      {:ok, _any = caps} -> %{keypair | clist: caps}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec validate_key(arg :: arg()) :: arg_validation()
  defp validate_key({_arg, key}) when is_binary(key) and byte_size(key) == 64, do: {:ok, key}
  defp validate_key({arg, _key}), do: {:error, [{arg, :invalid}]}

  @spec validate_caps_list(arg :: arg()) :: arg_validation()
  defp validate_caps_list({_arg, nil}), do: {:ok, nil}
  defp validate_caps_list({_arg, [%Cap{} | _tail] = clist}), do: {:ok, clist}
  defp validate_caps_list({arg, _clist}), do: {:error, [{arg, :invalid}]}

  defp create_clist({arg, caps}) when is_list(caps) do
    caps
    |> Enum.map(fn x -> Enum.map(x, fn {key, value} -> {String.to_atom(key), value} end) end)
    |> Enum.map(fn cap -> Cap.new(cap) end)
    |> (&validate_caps_list({arg, &1})).()
  end

  defp create_clist({_arg, nil}), do: {:ok, nil}
end
