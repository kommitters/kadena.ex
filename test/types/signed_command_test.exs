defmodule Kadena.Types.SignedCommandTest do
  @moduledoc """
  `SignedCommand` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Signature, SignedCommand}

  describe "new/1" do
    test "with a valid signature list" do
      signature1 =
        Signature.new("ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d")

      signature2 =
        Signature.new(
          "8c8932a6459945afb87dbce6f625d07d4bbaafcc01f570b279d41a3d0f51f18ac5f05c017581aab23459e0437b4715774dea80a67da41f3b1b3988b2d59c3c0a"
        )

      signatures_list = [signature1, signature2]

      %SignedCommand{
        hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
        sigs: [
          %Signature{
            sig: "ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d"
          },
          %Signature{
            sig:
              "8c8932a6459945afb87dbce6f625d07d4bbaafcc01f570b279d41a3d0f51f18ac5f05c017581aab23459e0437b4715774dea80a67da41f3b1b3988b2d59c3c0a"
          }
        ],
        cmd: "(+ 3 2)"
      } =
        SignedCommand.new(
          hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
          sigs: signatures_list,
          cmd: "(+ 3 2)"
        )
    end

    test "with a nil signatures list" do
      {:error, [sigs: :invalid]} =
        SignedCommand.new(
          hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
          sigs: nil,
          cmd: "(+ 3 2)"
        )
    end

    test "with an invalid hash" do
      signature1 = "ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d"

      signature2 =
        "8c8932a6459945afb87dbce6f625d07d4bbaafcc01f570b279d41a3d0f51f18ac5f05c017581aab23459e0437b4715774dea80a67da41f3b1b3988b2d59c3c0a"

      signature_list = [signature1, signature2]

      {:error, [hash: :invalid]} =
        SignedCommand.new(
          hash: 123,
          sigs: signature_list,
          cmd: "(+ 3 2)"
        )
    end

    test "with an invalid sig" do
      {:error, [sigs: :invalid]} =
        SignedCommand.new(
          hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
          sigs: 123,
          cmd: "(+ 3 2)"
        )
    end

    test "with an empty list" do
      {:error, [hash: :invalid]} = SignedCommand.new([])
    end

    test "with an incomplete list" do
      {:error, [sigs: :invalid]} =
        SignedCommand.new(
          hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
          cmd: "(+ 3 2)"
        )
    end
  end
end
