defmodule Kadena.Chainweb.Error do
  @moduledoc """
  Represents an error which occurred during a Chainweb API call.
  """

  @type title :: String.t() | atom()
  @type status :: 200..299 | 400..599 | :network_error
  @type error_source :: :chainweb | :network
  @type error_body :: map() | atom()
  @type error :: {error_source(), error_body()}

  @type t :: %__MODULE__{status: status(), title: title()}

  defstruct [:status, :title]

  @spec new(error :: error()) :: t()
  def new({:chainweb, %{status: status, title: title}}),
    do: %__MODULE__{status: status, title: title}

  def new({:network, error}), do: %__MODULE__{status: :network_error, title: error}
end
