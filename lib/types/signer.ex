defmodule Kadena.Types.Signer do
  @moduledoc """
  `Signer` struct definition.
  """

  alias Kadena.Types.{Base16String, CapsList, OptionalCapsList}

  @behaviour Kadena.Types.Spec

  @valid_schemes [:ed25519, nil]

  @type pub_key :: Base16String.t()
  @type scheme :: :ed25519 | nil
  @type addr :: Base16String.t() | nil
  @type clist :: OptionalCapsList.t()
  @type cap_list :: CapsList.t() | list() | nil
  @type value :: pub_key() | scheme() | addr() | clist()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{
          pub_key: pub_key(),
          scheme: scheme(),
          addr: addr(),
          clist: clist()
        }

  defstruct [:pub_key, :scheme, :addr, :clist]

  @impl true
  def new(args) do
    pub_key = Keyword.get(args, :pub_key)
    scheme = Keyword.get(args, :scheme)
    addr = Keyword.get(args, :addr)
    clist = Keyword.get(args, :clist)

    with {:ok, pub_key} <- validate_pub_key(pub_key),
         {:ok, scheme} <- validate_scheme(scheme),
         {:ok, addr} <- validate_addr(addr),
         {:ok, clist} <- validate_clist(clist) do
      %__MODULE__{pub_key: pub_key, scheme: scheme, addr: addr, clist: clist}
    end
  end

  @spec validate_pub_key(pub_key :: String.t()) :: validation()
  defp validate_pub_key(pub_key) when is_binary(pub_key), do: {:ok, Base16String.new(pub_key)}
  defp validate_pub_key(_pub_key), do: {:error, [pub_key: :invalid]}

  @spec validate_scheme(scheme :: String.t() | nil) :: validation()
  defp validate_scheme(scheme) when scheme in @valid_schemes, do: {:ok, scheme}
  defp validate_scheme(_code), do: {:error, [scheme: :invalid]}

  @spec validate_addr(addr :: String.t() | nil) :: validation()
  defp validate_addr(nil), do: {:ok, nil}
  defp validate_addr(addr) when is_binary(addr), do: {:ok, Base16String.new(addr)}
  defp validate_addr(_addr), do: {:error, [addr: :invalid]}

  @spec validate_clist(clist :: cap_list()) :: validation()
  defp validate_clist(nil), do: {:ok, OptionalCapsList.new()}
  defp validate_clist(%CapsList{} = clist), do: {:ok, OptionalCapsList.new(clist)}

  defp validate_clist(clist) do
    with %CapsList{} = clist <- CapsList.new(clist),
         %OptionalCapsList{} = optional_clist <- OptionalCapsList.new(clist) do
      {:ok, optional_clist}
    else
      {:error, [{_field, reason}]} -> {:error, [clist: reason]}
    end
  end
end
