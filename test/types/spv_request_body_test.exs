defmodule Kadena.Types.SPVRequestBodyTest do
  @moduledoc """
  `SPVRequestBody` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Base64Url, ChainID, SPVRequestBody}

  describe "new/1" do
    test "with a valid list" do
      %SPVRequestBody{request_key: %Base64Url{url: "ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q"}} =
        SPVRequestBody.new(
          request_key: "ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q",
          chain_id: "1"
        )
    end

    test "with a valid Base64Url ans ChainID struct" do
      request_key = Base64Url.new("ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q")
      chain_id = ChainID.new("1")

      %SPVRequestBody{
        request_key: ^request_key,
        chain_id: ^chain_id
      } = SPVRequestBody.new(request_key: request_key, chain_id: chain_id)
    end

    test "with an invalid request_key" do
      {:error, [request_key: :invalid]} = SPVRequestBody.new(request_key: nil)
    end

    test "with an invalid chain_id" do
      {:error, [chain_id: :invalid, id: :invalid]} =
        SPVRequestBody.new(
          request_key: "ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q",
          chain_id: nil
        )
    end

    test "with an invalid list" do
      {:error, [spv_request_body: :not_a_list]} = SPVRequestBody.new("invalid_param")
    end
  end
end
