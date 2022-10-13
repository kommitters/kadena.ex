defmodule Kadena.Cryptography.UtilsTest do
  @moduledoc """
  `Cryptography.Utils` functions tests.
  """

  use ExUnit.Case

  alias Kadena.Cryptography.Utils

  describe "bin and hex" do
    setup do
      %{
        hex:
          "8693e641ae2bbe9ea802c736f42027b03f86afe63cae315e7169c9c496c17332ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d",
        hex_bin:
          <<134, 147, 230, 65, 174, 43, 190, 158, 168, 2, 199, 54, 244, 32, 39, 176, 63, 134, 175,
            230, 60, 174, 49, 94, 113, 105, 201, 196, 150, 193, 115, 50, 186, 84, 178, 36, 209,
            146, 77, 217, 132, 3, 245, 199, 81, 171, 221, 16, 222, 108, 216, 27, 1, 33, 128, 11,
            247, 189, 189, 207, 174, 199, 56, 141>>
      }
    end

    test "hex_to_bin/1", %{hex: hex, hex_bin: hex_bin} do
      ^hex_bin = Utils.hex_to_bin(hex)
    end

    test "bin_to_hex/1", %{hex: hex, hex_bin: hex_bin} do
      ^hex = Utils.bin_to_hex(hex_bin)
    end
  end

  describe "url encode64 and decode64" do
    setup do
      %{
        hash: "zaqnRQ0RYzxTccjtYoBvQsDo5K9mxr4TEF-HIYTi5Jo",
        hash_bin:
          <<205, 170, 167, 69, 13, 17, 99, 60, 83, 113, 200, 237, 98, 128, 111, 66, 192, 232, 228,
            175, 102, 198, 190, 19, 16, 95, 135, 33, 132, 226, 228, 154>>
      }
    end

    test "with a valid decode", %{hash: hash, hash_bin: hash_bin} do
      ^hash_bin = Utils.url_decode64(hash)
    end

    test "with a valid encode", %{hash: hash, hash_bin: hash_bin} do
      ^hash = Utils.url_encode64(hash_bin)
    end
  end

  describe "blake2b_hash/2" do
    setup do
      %{
        blake32:
          <<1, 195, 111, 132, 126, 19, 6, 9, 42, 187, 129, 203, 232, 152, 2, 60, 146, 69, 153, 23,
            236, 101, 198, 127, 7, 162, 69, 84, 157, 167, 195, 182>>,
        blake64:
          <<83, 162, 244, 140, 76, 126, 210, 30, 186, 208, 13, 42, 97, 182, 131, 28, 214, 212, 20,
            22, 147, 2, 129, 126, 194, 22, 20, 196, 192, 95, 67, 45, 190, 189, 202, 2, 135, 33,
            100, 140, 59, 94, 107, 53, 229, 245, 214, 254, 40, 247, 116, 146, 246, 36, 173, 147,
            50, 206, 214, 152, 159, 36, 71, 117>>
      }
    end

    test "with default byte_size", %{blake32: blake32} do
      ^blake32 = Utils.blake2b_hash("zaqnRQ0RYzxTccjtYoBvQsDo5K9mxr4TEF-HIYTi5Joaa")
    end

    test "with custom byte_size", %{blake64: blake64} do
      ^blake64 =
        Utils.blake2b_hash("zaqnRQ0RYzxTccjtYoBvQsDo5K9mxr4TEF-HIYTi5Joaa", byte_size: 64)
    end
  end
end
