defmodule Kadena.Chainweb.Client.CannedPollRequests do
  @moduledoc false

  alias Kadena.Chainweb.Error
  alias Kadena.Test.Fixtures.Chainweb

  def request(
        :post,
        "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/0/pact/api/v1/poll",
        _headers,
        body,
        _options
      ) do
    case body == "{\"requestKeys\":[\"bad_length\"]}" do
      true ->
        response =
          Error.new(
            {:chainweb,
             %{
               status: 400,
               title: "Request Key  has incorrect hash of length 0"
             }}
          )

        {:error, response}

      false ->
        response = Chainweb.fixture("poll")
        {:ok, response}
    end
  end
end

defmodule Kadena.Chainweb.Pact.PollTest do
  @moduledoc """
  `Poll` endpoint implementation tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Client.CannedPollRequests
  alias Kadena.Chainweb.{Error, Pact}
  alias Kadena.Chainweb.Pact.{CommandResult, PollResponse}

  setup do
    Application.put_env(:kadena, :http_client_impl, CannedPollRequests)

    on_exit(fn ->
      Application.delete_env(:kadena, :http_client_impl)
    end)

    %{
      request_keys: [
        "bKT10kNSeAyE4LgfFInhorKpK_tNLcNjsaWgug4v82s",
        "ysx7BoerE0QpflZKkFhSjDZmvMf4xtZ0OxSL1EOckz0"
      ],
      response:
        {:ok,
         %PollResponse{
           results: [
             %CommandResult{
               continuation: nil,
               events: [
                 %{
                   module: %{name: "coin", namespace: nil},
                   module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4",
                   name: "TRANSFER",
                   params: [
                     "k:c891d6761ed2c4ccadbe6a1142803fd34fedfe9db110149cd1d8e2a7bc90dc2f",
                     "6d87fd6e5e47185cb421459d2888bddba7a6c0f2c4ae5246d5f38f993818bb89",
                     6.07e-4
                   ]
                 }
               ],
               gas: 607,
               logs: "OQzCLMH0ycZ0HPoN1F-2Rcifc4RuR4RmcO6t2iJI6A8",
               meta_data: %{
                 block_hash: "eNpIVqyanLWY3sGszNfgYN8YXWXDXfUsWbE_vWcNDlY",
                 block_height: 3_281_769,
                 block_time: 1_670_883_254_243_347,
                 prev_block_hash: "Tw4Z1exNzIinUFe3Y-rrbqp-iMo6NvQJQggMSeVNayw"
               },
               req_key: "bKT10kNSeAyE4LgfFInhorKpK_tNLcNjsaWgug4v82s",
               result: %{data: "Write succeeded", status: "success"},
               tx_id: 20_160_180
             },
             %CommandResult{
               continuation: nil,
               events: [
                 %{
                   module: %{name: "coin", namespace: nil},
                   module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4",
                   name: "TRANSFER",
                   params: [
                     "k:f99185285730c5414c0a1ec68924598b175827890fad20c18548a9b27d79ce2a",
                     "6d87fd6e5e47185cb421459d2888bddba7a6c0f2c4ae5246d5f38f993818bb89",
                     5.09e-4
                   ]
                 }
               ],
               gas: 509,
               logs: "_sMtjYp5hzhZSUgY72XoamRC0MJRJ_FlZ4IV6FQBK7I",
               meta_data: %{
                 block_hash: "eNpIVqyanLWY3sGszNfgYN8YXWXDXfUsWbE_vWcNDlY",
                 block_height: 3_281_769,
                 block_time: 1_670_883_254_243_347,
                 prev_block_hash: "Tw4Z1exNzIinUFe3Y-rrbqp-iMo6NvQJQggMSeVNayw"
               },
               req_key: "ysx7BoerE0QpflZKkFhSjDZmvMf4xtZ0OxSL1EOckz0",
               result: %{data: "Write succeeded", status: "success"},
               tx_id: 20_160_174
             }
           ]
         }}
    }
  end

  test "process/2", %{request_keys: request_keys, response: response} do
    ^response = Pact.poll(request_keys, network_id: :mainnet01, chain_id: 0)
  end

  test "process/2 error" do
    {:error,
     %Error{
       status: 400,
       title: "Request Key  has incorrect hash of length 0"
     }} = Pact.poll(["bad_length"], network_id: :mainnet01, chain_id: 0)
  end
end
