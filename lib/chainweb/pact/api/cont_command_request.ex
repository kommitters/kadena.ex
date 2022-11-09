defmodule Kadena.Chainweb.Pact.API.ContCommandRequest do
  @moduledoc false

  @type t :: %__MODULE__{to_do: String.t()}

  defstruct [:to_do]
end
