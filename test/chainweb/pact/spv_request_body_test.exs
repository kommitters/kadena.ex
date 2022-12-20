defmodule Kadena.Chainweb.Pact.SPVRequestBodyTest do
  @moduledoc """
  `SPVRequestBody` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Pact.SPVRequestBody
  alias Kadena.Types.{Base64Url, ChainID}

  describe "new/1" do
    test "with a valid list" do
      %SPVRequestBody{request_key: %Base64Url{url: "ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q"}} =
        SPVRequestBody.new(
          request_key: "ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q",
          target_chain_id: "1"
        )
    end

    test "with a valid Base64Url ans ChainID struct" do
      request_key = Base64Url.new("ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q")
      target_chain_id = ChainID.new("1")

      %SPVRequestBody{
        request_key: ^request_key,
        target_chain_id: ^target_chain_id
      } = SPVRequestBody.new(request_key: request_key, target_chain_id: target_chain_id)
    end

    test "with an invalid request_key" do
      {:error, [request_key: :invalid]} = SPVRequestBody.new(request_key: nil)
    end

    test "with an invalid target_chain_id" do
      {:error, [target_chain_id: :invalid, id: :invalid]} =
        SPVRequestBody.new(
          request_key: "ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q",
          target_chain_id: nil
        )
    end

    test "with an invalid list" do
      {:error, [spv_request_body: :not_a_list]} = SPVRequestBody.new("invalid_param")
    end
  end

  describe "JSONPayload.parse/1" do
    setup do
      %{
        json_result:
          "{\"requestKey\":\"7af34f24d55d2fcf5de6fccfeeb837698ebff4598303237c64348a47806c8646\",\"targetChainId\":\"1\"}"
      }
    end

    test "with a valid SPVRequestBody", %{
      json_result: json_result
    } do
      ^json_result =
        [
          request_key: "7af34f24d55d2fcf5de6fccfeeb837698ebff4598303237c64348a47806c8646",
          target_chain_id: "1"
        ]
        |> SPVRequestBody.new()
        |> SPVRequestBody.to_json!()
    end
  end
end
