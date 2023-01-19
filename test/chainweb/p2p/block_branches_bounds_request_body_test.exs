defmodule Kadena.Chainweb.P2P.BlockBranchesRequestBodyTest do
  @moduledoc """
  `BlockBranchesRequestBody` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.P2P.BlockBranchesRequestBody

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
      %BlockBranchesRequestBody{
        lower: ^lower,
        upper: ^upper
      } = BlockBranchesRequestBody.new(lower: lower, upper: upper)
    end

    test "with empty params" do
      %BlockBranchesRequestBody{
        lower: [],
        upper: []
      } = BlockBranchesRequestBody.new(lower: [], upper: [])
    end

    test "with invalid params" do
      {:error, [args: :not_a_string_list]} =
        BlockBranchesRequestBody.new(lower: "invalid", upper: "invalid")
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

    test "with a valid BlockBranchesRequestBody", %{
      lower: lower,
      upper: upper,
      json_result: json_result
    } do
      ^json_result =
        [lower: lower, upper: upper]
        |> BlockBranchesRequestBody.new()
        |> BlockBranchesRequestBody.to_json!()
    end
  end
end
