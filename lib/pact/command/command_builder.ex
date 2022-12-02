defmodule Pact.Command.CommandBuilder do
  @moduledoc """
    Functions who are necessary for both command exec and cont
  """
  alias Kadena.Cryptography.Sign
  alias Kadena.Types.{Command, KeyPair, SignaturesList, SignCommand}

  @type cmd :: String.t()
  @type command :: Command.t()
  @type hash :: String.t()
  @type json_string_payload :: String.t()
  @type keypair :: KeyPair.t()
  @type keypairs :: list(keypair())
  @type signatures :: SignaturesList.t()
  @type sign_command :: SignCommand.t()
  @type sign_commands :: list(sign_command())
  @type valid_command :: {:ok, command()}
  @type valid_hash :: {:ok, hash()}
  @type valid_signatures :: {:ok, signatures()}
  @type valid_sign_commands :: {:ok, [sign_command()]}

  @spec create_command(
          hash :: hash(),
          sigs :: signatures(),
          cmd :: cmd()
        ) :: valid_command()
  def create_command(hash, sigs, cmd) do
    case Command.new(hash: hash, sigs: sigs, cmd: cmd) do
      %Command{} = command -> {:ok, command}
    end
  end

  @spec sign_commands(signs :: list(), cmd :: json_string_payload(), keypairs()) ::
          valid_sign_commands()
  def sign_commands(signs, _cmd, []), do: {:ok, signs}

  def sign_commands(signs, cmd, [%KeyPair{} = keypair | keypairs]) do
    signs
    |> sign_command(cmd, keypair)
    |> sign_commands(cmd, keypairs)
  end

  @spec sign_command(signs :: list(), cmd :: json_string_payload(), keypair()) ::
          list()
  def sign_command(signs, cmd, %KeyPair{} = keypair) do
    {:ok, sign_command} = Sign.sign(cmd, keypair)
    signs ++ [sign_command]
  end

  @spec build_signatures(sign_commands :: sign_commands(), result :: list()) :: valid_signatures()
  def build_signatures([], result), do: {:ok, SignaturesList.new(result)}

  def build_signatures([%SignCommand{sig: sig} | rest], result),
    do: build_signatures(rest, result ++ [sig])

  @spec get_unique_hash(sign_commands()) :: valid_hash()
  def get_unique_hash(sign_commands) do
    unique_hash =
      Enum.reduce(sign_commands, nil, fn %SignCommand{hash: hash}, acc ->
        if is_nil(acc) or acc == hash,
          do: hash,
          else: {:error, [hash: :hashes_are_not_unique]}
      end)

    {:ok, unique_hash}
  end
end
