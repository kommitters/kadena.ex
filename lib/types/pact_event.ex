defmodule Kadena.Types.PactEvent do
  @moduledoc """
  `PactEventModule` struct definition.
  """

  alias Kadena.Types.{PactEventModule, PactValuesList}

  @behaviour Kadena.Types.Spec

  @type name :: String.t()
  @type pact_event_module :: PactEventModule.t()
  @type pact_event_module_arg :: pact_event_module() | list()
  @type params :: PactValuesList.t()
  @type params_arg :: params() | list()
  @type module_hash :: String.t()
  @type str :: String.t()
  @type value :: name() | pact_event_module_arg() | params_arg() | module_hash()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{
          name: name(),
          module: pact_event_module(),
          params: params(),
          module_hash: module_hash()
        }

  defstruct [:name, :module, :params, :module_hash]

  @impl true
  def new(args) do
    name = Keyword.get(args, :name)
    pact_event_module = Keyword.get(args, :module)
    params = Keyword.get(args, :params)
    module_hash = Keyword.get(args, :module_hash)

    with {:ok, name} <- validate_string(:name, name),
         {:ok, pact_event_module} <- validate_pact_event_module(pact_event_module),
         {:ok, params} <- validate_params(params),
         {:ok, module_hash} <- validate_string(:module_hash, module_hash) do
      %__MODULE__{name: name, module: pact_event_module, params: params, module_hash: module_hash}
    end
  end

  @spec validate_string(field :: atom(), value :: str()) :: validation()
  defp validate_string(_field, value) when is_binary(value), do: {:ok, value}
  defp validate_string(field, _value), do: {:error, [{field, :invalid}]}

  @spec validate_pact_event_module(pact_event_module :: pact_event_module_arg()) :: validation()
  defp validate_pact_event_module(%PactEventModule{} = pact_event_module),
    do: {:ok, pact_event_module}

  defp validate_pact_event_module(pact_event_module) when is_list(pact_event_module) do
    case PactEventModule.new(pact_event_module) do
      %PactEventModule{} = event_module -> {:ok, event_module}
      {:error, reason} -> {:error, [module: :invalid] ++ reason}
    end
  end

  defp validate_pact_event_module(_pact_event_module), do: {:error, [module: :invalid]}

  @spec validate_params(params :: params_arg()) :: validation()
  defp validate_params(%PactValuesList{} = pact_values), do: {:ok, pact_values}

  defp validate_params(params) when is_list(params) do
    case PactValuesList.new(params) do
      %PactValuesList{} = pact_values -> {:ok, pact_values}
      {:error, reason} -> {:error, [params: :invalid] ++ reason}
    end
  end

  defp validate_params(_params), do: {:error, [params: :invalid]}
end
