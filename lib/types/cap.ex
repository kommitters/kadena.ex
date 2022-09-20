defmodule Kadena.Types.Cap do
  @moduledoc """
  `Cap` struct definition.
  """

  alias Kadena.Types.PactValuesList

  @behaviour Kadena.Types.Spec

  @type args :: PactValuesList.t()
  @type t :: %__MODULE__{name: String.t(), args: args()}

  defstruct [:name, :args]

  @impl true
  def new(args) do
    name = Keyword.get(args, :name)
    args_list = Keyword.get(args, :args)

    with name when is_binary(name) <- name,
         %PactValuesList{} <- args_list do
      %__MODULE__{name: name, args: args_list}
    else
      _error -> {:error, :invalid_cap}
    end
  end
end
