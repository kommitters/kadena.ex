defmodule Kadena.Types.Signer do
  @moduledoc """
  `Signer` struct definition.
  """

  alias Kadena.Types.{Base16String, Cap}

  @behaviour Kadena.Types.Spec

  @valid_schemes [:ed25519, nil]

  @type pub_key :: Base16String.t()
  @type scheme :: :ed25519 | nil
  @type addr :: Base16String.t() | nil
  @type clist :: list(Cap.t())
  @type validation :: {:ok, any()} | {:error, atom()}
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
    clist = Keyword.get(args, :clist, [])

    with {:ok, pub_key} <- validate_pub_key(pub_key),
         {:ok, scheme} <- validate_scheme(scheme),
         {:ok, addr} <- validate_addr(addr),
         {:ok, clist} <- validate_clist(clist) do
      %__MODULE__{pub_key: pub_key, scheme: scheme, addr: addr, clist: clist}
    end
  end

  @spec validate_pub_key(pub_key :: pub_key()) :: validation()
  defp validate_pub_key(pub_key) when is_binary(pub_key), do: {:ok, Base16String.new(pub_key)}
  defp validate_pub_key(_pub_key), do: {:error, :invalid_pub_key}

  @spec validate_scheme(scheme :: scheme()) :: validation()
  defp validate_scheme(scheme) when scheme in @valid_schemes, do: {:ok, scheme}
  defp validate_scheme(_code), do: {:error, :invalid_scheme}

  @spec validate_addr(addr :: addr()) :: validation()
  defp validate_addr(nil), do: {:ok, Base16String.new()}
  defp validate_addr(addr) when is_binary(addr), do: {:ok, Base16String.new(addr)}
  defp validate_addr(_code), do: {:error, :invalid_addr}

  @spec validate_clist(clist :: clist(), response :: clist()) :: validation()
  defp validate_clist(clist, response \\ [])
  defp validate_clist([], response), do: {:ok, response}
  defp validate_clist([%Cap{} = clist_head | clist_tail], response), do: validate_clist(clist_tail, response ++ clist_head)
  defp validate_clist(_code, _response), do: {:error, :invalid_clist}
end
