defmodule Kadena.Chainweb.Pact.Resources.PactResult do
  @moduledoc """
  `PactResult` struct definition.
  """

  alias Kadena.Types.PactValue

  @behaviour Kadena.Chainweb.Resource

  @type status :: :success | :failure
  @type error :: map()
  @type data :: PactValue.t() | error()

  @type t :: %__MODULE__{
          status: status(),
          data: data()
        }

  defstruct [:status, :data]

  @impl true
  def new(%{"status" => "success", "data" => data}) do
    %__MODULE__{
      status: :success,
      data: PactValue.new(data)
    }
  end

  def new(%{"status" => "failure", "data" => data}) do
    %__MODULE__{
      status: :failure,
      data: data
    }
  end
end
