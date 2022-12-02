defmodule Kadena.Pact.Command.Hash do
  @moduledoc """
    Specifies function that checks if all the sign commands hashes are the same
  """
  alias Kadena.Types.SignCommand

  @type hash :: String.t()
  @type sign_command :: SignCommand.t()
  @type sign_commands :: list(sign_command())
  @type valid_hash :: {:ok, hash()}

  @spec pull_unique(sign_commands()) :: valid_hash()
  def pull_unique(sign_commands) do
    unique_hash =
      Enum.reduce(sign_commands, nil, fn %SignCommand{hash: hash}, acc ->
        if is_nil(acc) or acc == hash,
          do: hash,
          else: {:error, [hash: :not_unique]}
      end)

    {:ok, unique_hash}
  end
end
