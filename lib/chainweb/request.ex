defmodule Kadena.Chainweb.Request do
  @moduledoc """
  A module to work with Chainweb requests.
  Requests are composed in a functional manner.
  The request does not happen until it is configured and passed to `perform/1`.
  """

  alias Kadena.Chainweb.{Client, Error, Network}

  @type api_type :: :pact | :p2p
  @type network_id :: :testnet04 | :mainnet01
  @type chain_id :: String.t() | nil
  @type method :: :get | :post | :put
  @type headers :: [{binary(), binary()}]
  @type body :: String.t() | nil
  @type query :: Keyword.t()
  @type encoded_query :: String.t() | nil
  @type endpoint :: String.t() | nil
  @type path :: String.t() | nil
  @type segment :: String.t() | nil
  @type opts :: Keyword.t()
  @type params :: Keyword.t()
  @type response :: {:ok, map()} | {:error, Error.t()}
  @type parsed_response :: {:ok, struct()} | {:error, Error.t()}

  @type t :: %__MODULE__{
          method: method(),
          api_type: api_type(),
          network_id: network_id(),
          chain_id: chain_id(),
          endpoint: endpoint(),
          path: path(),
          segment: segment(),
          segment_path: path(),
          query: query(),
          headers: headers(),
          body: body(),
          encoded_query: encoded_query()
        }

  defstruct [
    :method,
    :api_type,
    :network_id,
    :chain_id,
    :endpoint,
    :path,
    :segment,
    :segment_path,
    :query,
    :headers,
    :body,
    :encoded_query
  ]

  @spec new(method :: method(), opts :: opts()) :: t()
  def new(method, [{api_type, opts}]) when api_type in [:pact, :p2p] do
    network_id = Keyword.get(opts, :network_id)
    chain_id = Keyword.get(opts, :chain_id)
    endpoint = Keyword.get(opts, :endpoint)
    path = Keyword.get(opts, :path)
    segment = Keyword.get(opts, :segment)
    segment_path = Keyword.get(opts, :segment_path)

    %__MODULE__{
      method: method,
      api_type: api_type,
      network_id: network_id,
      chain_id: chain_id,
      endpoint: endpoint,
      path: path,
      segment: segment,
      segment_path: segment_path,
      query: [],
      headers: []
    }
  end

  @spec set_chain_id(t(), chain_id :: chain_id()) :: t()
  def set_chain_id(%__MODULE__{} = request, chain_id), do: %{request | chain_id: chain_id}

  @spec set_network(t(), network :: network_id()) :: t()
  def set_network(%__MODULE__{} = request, network), do: %{request | network_id: network}

  @spec add_body(request :: t(), body :: body()) :: t()
  def add_body(%__MODULE__{} = request, body), do: %{request | body: body}

  @spec add_headers(request :: t(), headers :: headers()) :: t()
  def add_headers(%__MODULE__{} = request, headers), do: %{request | headers: headers}

  @spec add_query(request :: t(), params :: params()) :: t()
  def add_query(%__MODULE__{} = request, params),
    do: %{request | query: params, encoded_query: build_query_string(params)}

  @spec perform(request :: t()) :: response()
  def perform(%__MODULE__{method: method, headers: headers, body: body} = request) do
    request
    |> build_request_url()
    |> (&Client.request(method, &1, headers, body)).()
  end

  @spec results(response :: response(), opts :: opts()) :: parsed_response()
  def results({:ok, results}, as: resource), do: {:ok, resource.new(results)}
  def results({:error, error}, _resource), do: {:error, error}

  @spec build_request_url(request :: t()) :: binary()
  defp build_request_url(
         %__MODULE__{
           endpoint: endpoint,
           path: path,
           segment: segment,
           segment_path: segment_path,
           encoded_query: encoded_query
         } = request
       ) do
    base_url = Network.base_url(request)

    IO.iodata_to_binary([
      if(base_url, do: base_url, else: []),
      if(endpoint, do: ["/" | to_string(endpoint)], else: []),
      if(path, do: ["/" | to_string(path)], else: []),
      if(segment, do: ["/" | to_string(segment)], else: []),
      if(segment_path, do: ["/" | to_string(segment_path)], else: []),
      if(encoded_query, do: ["?" | encoded_query], else: [])
    ])
  end

  @spec build_query_string(params :: params()) :: encoded_query()
  defp build_query_string(params) do
    params
    |> Enum.reject(&is_empty_param/1)
    |> encode_query()
  end

  @spec encode_query(query :: query()) :: encoded_query()
  defp encode_query([]), do: nil
  defp encode_query(query), do: URI.encode_query(query)

  @spec is_empty_param(param :: {atom(), any()}) :: boolean()
  defp is_empty_param({_key, nil}), do: true
  defp is_empty_param({_key, value}), do: to_string(value) == ""
end
