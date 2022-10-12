defmodule Kadena.Types.CommandPayloadStringifiedJSONTest do
  @moduledoc """
  `CommandPayloadStringifiedJSON` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.CommandPayloadStringifiedJSON

  describe "new/1" do
    test "with a valid value" do
      command_payload =
        ~s({"networkId":null,"payload":{"cont":{"proof":null,"pactId":"TNgO7o8nSZILVCfJPcg5IjHADy-XKvQ7o5RfAieJvwY","rollback":false,"step":1,"data":{}}},"signers":[{"pubKey":"ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d"}],"meta":{"creationTime":0,"ttl":0,"gasLimit":0,"chainId":"","gasPrice":0,"sender":""},"nonce":"\\"step01\\""})

      %CommandPayloadStringifiedJSON{json_string: ^command_payload} =
        CommandPayloadStringifiedJSON.new(command_payload)
    end

    test "with an invalid value" do
      {:error, [json_string: :invalid]} = CommandPayloadStringifiedJSON.new(nil)
    end
  end
end
