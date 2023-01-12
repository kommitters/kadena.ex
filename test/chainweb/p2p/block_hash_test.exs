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

  def request(
        :post,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/hash/branch",
        _headers,
        "{\"lower\":[],\"upper\":[\"\"]}",
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title: "Error in $.upper[0]: DecodeException \"not enough bytes\""
         }}
      )

    {:error, response}
  end

  def request(
        :post,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/hash/branch",
        _headers,
        "{\"lower\":[\"hello\"],\"upper\":[]}",
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title: "Error in $.lower[0]: Base64DecodeException \"invalid padding near offset 4\""
         }}
      )

    {:error, response}
  end

  def request(
        :post,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/hash/branch",
        _headers,
        "{\"lower\":[123,321],\"upper\":[400,403]}",
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title:
             "Error in $.lower[0]: parsing BlockHash failed, expected String, but encountered Number"
         }}
      )

    {:error, response}
  end

  def request(
        :post,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/hash/branch?limit=3&minheight=0&maxheight=6",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("block_hash_retrieve_branches")
    {:ok, response}
  end

  def request(
        :post,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/hash/branch",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("block_hash_retrieve_branches_2")
    {:ok, response}
  end

  def request(
        :post,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/1/hash/branch",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 404,
           title:
             "{\"reason\":\"key not found\",\"key\":\"HHEJ8CfvcweMTfvSMBYlXLWv0v25Mt-4bK3RUi_L6ls\"}"
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

  describe "retrieve/1" do
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

  describe "retrieve_branches/2" do
    setup do
      Application.put_env(:kadena, :http_client_impl, CannedBlockHashRequests)

      on_exit(fn ->
        Application.delete_env(:kadena, :http_client_impl)
      end)

      lower = ["4kaI5Wk-t3mvNZoBmVECbk_xge5SujrVh1s8S-GESKI"]
      upper = ["HHEJ8CfvcweMTfvSMBYlXLWv0v25Mt-4bK3RUi_L6ls"]

      success_response =
        {:ok,
         %BlockHashResponse{
           items: [
             "HHEJ8CfvcweMTfvSMBYlXLWv0v25Mt-4bK3RUi_L6ls",
             "gmV-pRi50fUcy2i9v8cba_HDjw2_GP47RKgpKD-0av8",
             "jVP-BDWC93RfDzBVQxolPJi7RcX09ax1IMg0_I_MNIk"
           ],
           limit: 3,
           next: nil
         }}

      success_response2 =
        {:ok,
         %BlockHashResponse{
           items: [
             "HHEJ8CfvcweMTfvSMBYlXLWv0v25Mt-4bK3RUi_L6ls",
             "gmV-pRi50fUcy2i9v8cba_HDjw2_GP47RKgpKD-0av8",
             "jVP-BDWC93RfDzBVQxolPJi7RcX09ax1IMg0_I_MNIk",
             "4kaI5Wk-t3mvNZoBmVECbk_xge5SujrVh1s8S-GESKI",
             "M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd0yUQA",
             "3eH11vI_wZuP3lEKcilfCx89_kZ78nFuJJbty44iNBo",
             "r21zg8E011awAbEghzNBOI4RtKUZ-wHLkUwio-5dKpE"
           ],
           limit: 7,
           next: nil
         }}

      %{
        lower: lower,
        upper: upper,
        success_response: success_response,
        success_response2: success_response2
      }
    end

    test "success", %{success_response: success_response, lower: lower, upper: upper} do
      ^success_response =
        BlockHash.retrieve_branches([lower: lower, upper: upper],
          query_params: [limit: 3, minheight: 0, maxheight: 6]
        )
    end

    test "success with only upper", %{success_response2: success_response2, upper: upper} do
      ^success_response2 = BlockHash.retrieve_branches(upper: upper)
    end

    test "error when hashes not in the chain", %{lower: lower, upper: upper} do
      {:error,
       %Error{
         status: 404,
         title:
           "{\"reason\":\"key not found\",\"key\":\"HHEJ8CfvcweMTfvSMBYlXLWv0v25Mt-4bK3RUi_L6ls\"}"
       }} = BlockHash.retrieve_branches([lower: lower, upper: upper], chain_id: 1)
    end

    test "error with an invalid upper hash" do
      {:error,
       %Error{status: 400, title: "Error in $.upper[0]: DecodeException \"not enough bytes\""}} =
        BlockHash.retrieve_branches(upper: [""])
    end

    test "hash decode error" do
      {:error,
       %Error{
         status: 400,
         title: "Error in $.lower[0]: Base64DecodeException \"invalid padding near offset 4\""
       }} = BlockHash.retrieve_branches(lower: ["hello"])
    end

    test "hash parsing error" do
      {:error,
       %Error{
         status: 400,
         title:
           "Error in $.lower[0]: parsing BlockHash failed, expected String, but encountered Number"
       }} = BlockHash.retrieve_branches(lower: [123, 321], upper: [400, 403])
    end
  end
end
