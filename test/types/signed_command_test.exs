defmodule Kadena.Types.SignedCommandTest do
  @moduledoc """
  `SignedCommand` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Signature, SignaturesList, SignedCommand}

  describe "new/1" do
    test "with a valid signature list" do
      signature1 = Signature.new("valid signature1")
      signature2 = Signature.new("valid signature2")
      signatures_list = SignaturesList.new([signature1, signature2])

      %SignedCommand{
        hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
        sigs: ^signatures_list,
        cmd: "valid_command"
      } =
        SignedCommand.new(
          hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
          sigs: signatures_list,
          cmd: "valid_command"
        )
    end

    test "with a nil signatures list" do
      {:error, :invalid_signed_command} =
        SignedCommand.new(
          hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
          sigs: nil,
          cmd: "valid_command"
        )
    end

    test "with an invalid hash" do
      signature1 = Signature.new("valid signature1")
      signature2 = Signature.new("valid signature2")
      signature_list = SignaturesList.new([signature1, signature2])

      {:error, :invalid_signed_command} =
        SignedCommand.new(
          hash: 123,
          sigs: signature_list,
          cmd: "valid_command"
        )
    end

    test "with an invalid sig" do
      {:error, :invalid_signed_command} =
        SignedCommand.new(
          hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
          sigs: 123,
          cmd: "valid_command"
        )
    end

    test "with an empty list" do
      {:error, :invalid_signed_command} = SignedCommand.new([])
    end

    test "with an empty sigs list" do
      {:error, :invalid_signed_command} =
        SignedCommand.new(
          hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
          sigs: [],
          cmd: "valid_command"
        )
    end

    test "with an incomplete list" do
      {:error, :invalid_signed_command} =
        SignedCommand.new(
          hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
          cmd: "valid_command"
        )
    end
  end
end
