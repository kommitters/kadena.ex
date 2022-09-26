defmodule Kadena.Types.CommandResultTest do
  @moduledoc """
  `CommandResult` struct definition tests.
  """

  # use ExUnit.Case

  # alias Kadena.Types.{Base64Url, CommandResult, PactResultError, PactResultSuccess, PactValue}

  # describe "new/1" do
  #   setup do
  #     %{
  #       req_key: Base64Url.new("yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4"),
  #       tx_id: 2,
  #       result: 3 |> PactValue.new() |> PactResultSuccess.new(),
  #       gas: 0,
  #       logs: "wsATyGqckuIvlm89hhd2j4t6RMkCrcwJe_oeCYr7Th8",
  #       continuation: nil,
  #       meta_data: nil
  #     }
  #   end

  #   test "with a valid param list", %{
  #     req_key: req_key,
  #     tx_id: tx_id,
  #     result: result,
  #     gas: gas,
  #     logs: logs,
  #     continuation: continuation,
  #     meta_data: meta_data
  #   } do
  #     %CommandResult{
  #       req_key: ^req_key,
  #       tx_id: ^tx_id,
  #       result: ^result,
  #       gas: ^gas,
  #       logs: ^logs,
  #       continuation: ^continuation,
  #       meta_data: ^meta_data
  #     } =
  #       CommandResult.new(
  #         req_key: req_key,
  #         tx_id: tx_id,
  #         result: result,
  #         gas: gas,
  #         logs: logs,
  #         continuation: continuation,
  #         meta_data: meta_data
  #       )
  #   end

  #   test "with an invalid empty list", %{
  #     req_key: req_key,
  #     tx_id: tx_id,
  #     result: result,
  #     gas: gas,
  #     logs: logs,
  #     continuation: continuation,
  #     meta_data: meta_data
  #   } do
  #     {:error, :invalid_req_key} = CommandResult.new([])
  #   end

  #   test "with an invalid req_key", %{
  #     tx_id: tx_id,
  #     result: result,
  #     gas: gas,
  #     logs: logs,
  #     continuation: continuation,
  #     meta_data: meta_data
  #   } do
  #     {:error, :invalid_req_key} =
  #       CommandResult.new(
  #         req_key: :req_key,
  #         tx_id: tx_id,
  #         result: result,
  #         gas: gas,
  #         logs: logs,
  #         continuation: continuation,
  #         meta_data: meta_data
  #       )
  #   end

  #   test "with an invalid tx_id", %{
  #     req_key: req_key,
  #     result: result,
  #     gas: gas,
  #     logs: logs,
  #     continuation: continuation,
  #     meta_data: meta_data
  #   } do
  #     {:error, :invalid_tx_id} =
  #       CommandResult.new(
  #         req_key: req_key,
  #         tx_id: "2",
  #         result: result,
  #         gas: gas,
  #         logs: logs,
  #         continuation: continuation,
  #         meta_data: meta_data
  #       )
  #   end

  #   test "with an invalid result", %{
  #     req_key: req_key,
  #     tx_id: tx_id,
  #     gas: gas,
  #     logs: logs,
  #     continuation: continuation,
  #     meta_data: meta_data
  #   } do
  #     {:error, :invalid_result} =
  #       CommandResult.new(
  #         req_key: req_key,
  #         tx_id: tx_id,
  #         result: 3,
  #         gas: gas,
  #         logs: logs,
  #         continuation: continuation,
  #         meta_data: meta_data
  #       )
  #   end

  #   test "with an invalid gas", %{
  #     req_key: req_key,
  #     tx_id: tx_id,
  #     result: result,
  #     logs: logs,
  #     continuation: continuation,
  #     meta_data: meta_data
  #   } do
  #     {:error, :invalid_gas} =
  #       CommandResult.new(
  #         req_key: req_key,
  #         tx_id: tx_id,
  #         result: result,
  #         gas: "2500",
  #         logs: logs,
  #         continuation: continuation,
  #         meta_data: meta_data
  #       )
  #   end

  #   test "with an invalid logs", %{
  #     req_key: req_key,
  #     tx_id: tx_id,
  #     result: result,
  #     gas: gas,
  #     continuation: continuation,
  #     meta_data: meta_data
  #   } do
  #     {:error, :invalid_logs} =
  #       CommandResult.new(
  #         req_key: req_key,
  #         tx_id: tx_id,
  #         result: result,
  #         gas: gas,
  #         logs: :error,
  #         continuation: continuation,
  #         meta_data: meta_data
  #       )
  #   end

  #   test "with an invalid continuation", %{
  #     req_key: req_key,
  #     tx_id: tx_id,
  #     result: result,
  #     gas: gas,
  #     logs: logs,
  #     meta_data: meta_data
  #   } do
  #     {:error, :invalid_continuation} =
  #       CommandResult.new(
  #         req_key: req_key,
  #         tx_id: tx_id,
  #         result: result,
  #         gas: gas,
  #         logs: logs,
  #         continuation: true,
  #         meta_data: meta_data
  #       )
  #   end

  #   test "with an invalid meta_data", %{
  #     req_key: req_key,
  #     tx_id: tx_id,
  #     result: result,
  #     gas: gas,
  #     logs: logs,
  #     continuation: continuation
  #   } do
  #     {:error, :invalid} =
  #       CommandResult.new(
  #         req_key: req_key,
  #         tx_id: tx_id,
  #         result: result,
  #         gas: gas,
  #         logs: logs,
  #         continuation: continuation,
  #         meta_data: "meta_data"
  #       )
  #   end
  # end
end
