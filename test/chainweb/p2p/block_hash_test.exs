defmodule Kadena.Chainweb.Client.CannedBlockHashRequests do
  @moduledoc false

  alias Kadena.Chainweb.Error
  alias Kadena.Test.Fixtures.Chainweb

  def request(
        :get,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/hash?limit=2",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("block_hash_retrieve")
    {:ok, response}
  end

  def request(
        :get,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/hash?limit=5&next=inclusive%3AM4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd0yUQA&minheight=0&maxheight=50000",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("block_hash_retrieve_2")
    {:ok, response}
  end

  def request(
        :get,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/hash?limit=5&next=invalid&minheight=0&maxheight=50000",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title:
             "Error parsing query parameter next failed: TextFormatException \"missing ':' in next item: \\\"invalid\\\".\""
         }}
      )

    {:error, response}
  end

  def request(
        :get,
        "https://col1.chainweb.com/chainweb/0.0/mainnet01/chain/0/hash",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: :network_error,
           title: :nxdomain
         }}
      )

    {:error, response}
  end

  def request(
        :get,
        "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/20/hash",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 404,
           title: "not found"
         }}
      )

    {:error, response}
  end
end

defmodule Kadena.Chainweb.P2P.BlockHashTest do
  @moduledoc """
  `BlockHash` endpoints implementation tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Client.CannedBlockHashRequests
  alias Kadena.Chainweb.Error
  alias Kadena.Chainweb.P2P.{BlockHash, BlockHashResponse}

  setup do
    Application.put_env(:kadena, :http_client_impl, CannedBlockHashRequests)

    on_exit(fn ->
      Application.delete_env(:kadena, :http_client_impl)
    end)

    success_response =
      {:ok,
       %BlockHashResponse{
         items: [
           "r21zg8E011awAbEghzNBOI4RtKUZ-wHLkUwio-5dKpE",
           "3eH11vI_wZuP3lEKcilfCx89_kZ78nFuJJbty44iNBo"
         ],
         limit: 2,
         next: "inclusive:M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd0yUQA"
       }}

    success_response2 =
      {:ok,
       %BlockHashResponse{
         items: [
           "M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd0yUQA",
           "4kaI5Wk-t3mvNZoBmVECbk_xge5SujrVh1s8S-GESKI",
           "jVP-BDWC93RfDzBVQxolPJi7RcX09ax1IMg0_I_MNIk",
           "gmV-pRi50fUcy2i9v8cba_HDjw2_GP47RKgpKD-0av8",
           "HHEJ8CfvcweMTfvSMBYlXLWv0v25Mt-4bK3RUi_L6ls"
         ],
         limit: 5,
         next: "inclusive:A_J0hFzXonhYkApgpIUR0dcmwVl8x7xDzKgYNRZpwis"
       }}

    %{
      success_response: success_response,
      success_response2: success_response2
    }
  end

  describe "retrieve/1" do
    test "success", %{success_response: success_response} do
      ^success_response = BlockHash.retrieve(query_params: [limit: 2])
    end

    test "success with all query params", %{success_response2: success_response2} do
      ^success_response2 =
        BlockHash.retrieve(
          query_params: [
            limit: 5,
            next: "inclusive:M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd0yUQA",
            minheight: 0,
            maxheight: 50_000
          ]
        )
    end
  end

  test "error with an invalid next" do
    {:error,
     %Error{
       status: 400,
       title:
         "Error parsing query parameter next failed: TextFormatException \"missing ':' in next item: \\\"invalid\\\".\""
     }} =
      BlockHash.retrieve(
        query_params: [limit: 5, next: "invalid", minheight: 0, maxheight: 50_000]
      )
  end

  test "error with an invalid chain_id" do
    {:error, %Error{status: 404, title: "not found"}} =
      BlockHash.retrieve(network_id: :mainnet01, chain_id: "20")
  end

  test "error with a non existing location" do
    {:error, %Error{status: :network_error, title: :nxdomain}} =
      BlockHash.retrieve(location: "col1", network_id: :mainnet01)
  end
end
