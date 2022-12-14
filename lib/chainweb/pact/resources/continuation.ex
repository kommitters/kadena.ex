defmodule Kadena.Chainweb.Pact.Resources.Continuation do
  @moduledoc """
  `Continuation` struct definition.
  """

  alias Kadena.Chainweb.Mapping
  alias Kadena.Types.PactValue

  @behaviour Kadena.Chainweb.Resource

  @type continuation_def :: String.t()
  @type args :: PactValue.t()

  @type t :: %__MODULE__{
          def: continuation_def(),
          args: args()
        }

  defstruct [:def, :args]

  @mapping [args: {:struct, PactValue}]

  @impl true
  def new(attrs) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
