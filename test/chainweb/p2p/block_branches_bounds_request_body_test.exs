defmodule Kadena.Chainweb.P2P.BlockBranchesBoundsRequestBodyTest do
  @moduledoc """
  `BlockBranchesBoundsRequestBody` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.P2P.BlockBranchesBoundsRequestBody

  describe "new/1" do
    setup do
      lower = ["4kaI5Wk-t3mvNZoBmVECbk_xge5SujrVh1s8S-GESKI"]
      upper = ["HHEJ8CfvcweMTfvSMBYlXLWv0v25Mt-4bK3RUi_L6ls"]

      %{
        lower: lower,
        upper: upper
      }
    end

    test "with valid params", %{lower: lower, upper: upper} do
      %BlockBranchesBoundsRequestBody{
        lower: ^lower,
        upper: ^upper
      } = BlockBranchesBoundsRequestBody.new(lower: lower, upper: upper)
    end

    test "with empty params" do
      %BlockBranchesBoundsRequestBody{
        lower: [],
        upper: []
      } = BlockBranchesBoundsRequestBody.new(lower: [], upper: [])
    end

    test "with invalid params" do
      {:error, [args: :not_a_string_list]} =
        BlockBranchesBoundsRequestBody.new(lower: "invalid", upper: "invalid")
    end
  end

  describe "to_json!/1" do
    setup do
      lower = ["4kaI5Wk-t3mvNZoBmVECbk_xge5SujrVh1s8S-GESKI"]
      upper = ["HHEJ8CfvcweMTfvSMBYlXLWv0v25Mt-4bK3RUi_L6ls"]

      %{
        lower: lower,
        upper: upper,
        json_result:
          "{\"lower\":[\"4kaI5Wk-t3mvNZoBmVECbk_xge5SujrVh1s8S-GESKI\"],\"upper\":[\"HHEJ8CfvcweMTfvSMBYlXLWv0v25Mt-4bK3RUi_L6ls\"]}"
      }
    end

    test "with a valid BlockBranchesBoundsRequestBody", %{
      lower: lower,
      upper: upper,
      json_result: json_result
    } do
      ^json_result =
        [lower: lower, upper: upper]
        |> BlockBranchesBoundsRequestBody.new()
        |> BlockBranchesBoundsRequestBody.to_json!()
    end
  end
end
