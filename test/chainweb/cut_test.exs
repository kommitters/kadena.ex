defmodule Kadena.Chainweb.CutTest do
  @moduledoc """
  `Cut` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Cut

  setup do
    hashes = %{
      "0": %{hash: "N5oyYlCvq6VvyoqioTQClWXAudf_ap3gqXxSpr4V32w", height: 3_362_200},
      "1": %{hash: "CK2XPSueEx8EdkIehFMUadEBnMKZTPOfgM5-fEyoYbw", height: 3_362_200},
      "10": %{hash: "96YYw5pRg4MBjkNFDl9Xp7jHbOnagJMj7X5dCqZ60XU", height: 3_362_200},
      "11": %{hash: "pFUCltdbMKaPNIbD5UmYPOlI39JGPKB5btukDg0UDu4", height: 3_362_199},
      "12": %{hash: "DUmXlz012BHJ4E_yrer4KreqjJLFbt9MBshgJ_et6TA", height: 3_362_200},
      "13": %{hash: "FjR3WBYQDaDvSiiq56gyV71DZrBiu83zupTbfBG_-ig", height: 3_362_199},
      "14": %{hash: "gmNKndByH1bTC-3Ta_v387x1E-7esY9Vn3vYPcWr-vw", height: 3_362_200},
      "15": %{hash: "jFrXJGikDL71aLn4g6HP4hDQKWQFYSIFjdca4__pu2c", height: 3_362_200},
      "16": %{hash: "WEVmzdin0Rb5WAlYczcIWOFtyzSZQosVFGaqbhbQ-N8", height: 3_362_200},
      "17": %{hash: "GBOnwWBFpKzMRbfixDwWTMcM2ViLld0EAVdnmgWsbx8", height: 3_362_200},
      "18": %{hash: "-B6DtXsobMyJ2kQHr60CHMskur6pA7snFu140Utiyzk", height: 3_362_199},
      "19": %{hash: "dWJGDWMSqqHiTjKKKPlSTegNqF3oGFURslo43hs-WtM", height: 3_362_200},
      "2": %{hash: "Mh2UjcEWgqYoyueYlq2tGa136cq3V4OOg7bmYHdfebI", height: 3_362_200},
      "3": %{hash: "rzXbneFCATH1XTPbCrGlFBFQGkKV5PNzOW7F2IRiCsE", height: 3_362_198},
      "4": %{hash: "SMDq8UsGZBR1JL9uiPIjzWgqzQg0uGB2QhmgJb3nt7k", height: 3_362_200},
      "5": %{hash: "WlkYOwmc8ToRsPb6RBl814R-RdhpL4rw5sBbW98d414", height: 3_362_199},
      "6": %{hash: "khQSsOZvKQCickhbp19ovrpIQNYQgCc9oAJ2veSxt6c", height: 3_362_199},
      "7": %{hash: "EdsyQ0S5O1zNYZ5TBS7VnwstBwaaSFoWR1JSaLt6ESU", height: 3_362_200},
      "8": %{hash: "9eexjG99ScAoMkxrEmtVPAMEis0ZsY_05ZBVyj1hdP8", height: 3_362_199},
      "9": %{hash: "uAB0hM5bNmvXbtvuohcXH6DSX6bnZ3yGhdTJvvBYzC4", height: 3_362_200}
    }

    hashes2 = %{
      "0": %{hash: "N5oyYlCvq6VvyoqioTQClWXAudf_ap3gqXxSpr4V32w", height: 3_362_200},
      "1": %{hash: "CK2XPSueEx8EdkIehFMUadEBnMKZTPOfgM5-fEyoYbw", height: 3_362_200}
    }

    invalid_hashes = %{
      "21": %{hash: "N5oyYlCvq6VvyoqioTQClWXAudf_ap3gqXxSpr4V32w", height: 3_362_200},
      invalid: %{hash: "CK2XPSueEx8EdkIehFMUadEBnMKZTPOfgM5-fEyoYbw", height: 3_362_200}
    }

    hashes_with_removed_item = %{
      "1": %{hash: "CK2XPSueEx8EdkIehFMUadEBnMKZTPOfgM5-fEyoYbw", height: 3_362_200}
    }

    origin = %{
      id: "VsCK48567Tu5v4NucnGiB7Wp6QSf2K2UjiBbxW_XSgE",
      address: %{
        hostname: "hetzner-eu-13-58.poolmon.net",
        port: 4443
      }
    }

    height = 67_243_992
    id = "PXbSJgmFjN3A4DSz37ttYWmyrpDfzCoyivVflV3VL9A"
    instance = "mainnet01"
    weight = "zrmhnWgsJ-5v9gMAAAAAAAAAAAAAAAAAAAAAAAAAAAA"

    %{
      hashes: hashes,
      hashes2: hashes2,
      hashes_with_removed_item: hashes_with_removed_item,
      invalid_hashes: invalid_hashes,
      height: height,
      id: id,
      instance: instance,
      origin: origin,
      weight: weight
    }
  end

  describe "create Cut" do
    test "with valid list args", %{
      hashes: hashes,
      height: height,
      id: id,
      instance: instance,
      origin: origin,
      weight: weight
    } do
      %Cut{
        hashes: ^hashes,
        height: ^height,
        id: ^id,
        instance: ^instance,
        origin: ^origin,
        weight: ^weight
      } =
        Cut.new(
          hashes: hashes,
          height: height,
          id: id,
          instance: instance,
          origin: origin,
          weight: weight
        )
    end

    test "with valid map args", %{
      hashes: hashes,
      height: height,
      id: id,
      instance: instance,
      origin: origin,
      weight: weight
    } do
      %Cut{
        hashes: ^hashes,
        height: ^height,
        id: ^id,
        instance: ^instance,
        origin: ^origin,
        weight: ^weight
      } =
        Cut.new(%{
          hashes: hashes,
          height: height,
          id: id,
          instance: instance,
          origin: origin,
          weight: weight
        })
    end

    test "with an invalid args" do
      {:error, [args: :invalid_format]} = Cut.new("invalid")
    end

    test "Using functions", %{
      hashes2: hashes2,
      height: height,
      id: id,
      instance: instance,
      origin: origin,
      weight: weight
    } do
      %Cut{
        hashes: ^hashes2,
        height: ^height,
        id: ^id,
        instance: ^instance,
        origin: ^origin,
        weight: ^weight
      } =
        Cut.new()
        |> Cut.set_hashes(hashes2)
        |> Cut.add_hash(10, %{
          hash: "96YYw5pRg4MBjkNFDl9Xp7jHbOnagJMj7X5dCqZ60XU",
          height: 3_362_200
        })
        |> Cut.remove_hash(10)
        |> Cut.set_height(height)
        |> Cut.set_id(id)
        |> Cut.set_instance(instance)
        |> Cut.set_origin(origin)
        |> Cut.set_weight(weight)
    end

    test "with a hash removing", %{
      hashes2: hashes2,
      hashes_with_removed_item: hashes_with_removed_item,
      height: height,
      id: id,
      instance: instance,
      origin: origin,
      weight: weight
    } do
      cut =
        Cut.new(
          hashes: hashes2,
          height: height,
          id: id,
          instance: instance,
          origin: origin,
          weight: weight
        )

      %Cut{
        hashes: ^hashes_with_removed_item,
        height: ^height,
        id: ^id,
        instance: ^instance,
        origin: ^origin,
        weight: ^weight
      } = Cut.remove_hash(cut, 0)
    end

    test "with an invalid hashes: not a map" do
      {:error, [hashes: :not_a_map]} = Cut.set_hashes(Cut.new(), "invalid_value")
    end

    test "with an invalid hashes: invalid content", %{invalid_hashes: invalid_hashes} do
      {:error, [hashes: [args: :invalid]]} = Cut.set_hashes(Cut.new(), invalid_hashes)
    end

    test "with an invalid hash: invalid map" do
      {:error, [args: :invalid]} = Cut.add_hash(Cut.new(), 2, "invalid_value")
    end

    test "with an invalid hash: chain_id greater than 19" do
      {:error, [args: :invalid]} =
        Cut.add_hash(Cut.new(), 23, %{
          hash: "CK2XPSueEx8EdkIehFMUadEBnMKZTPOfgM5-fEyoYbw",
          height: 3_362_200
        })
    end

    test "with an invalid hash: chain_id as string" do
      {:error, [args: :invalid]} =
        Cut.add_hash(Cut.new(), "invalid", %{
          hash: "CK2XPSueEx8EdkIehFMUadEBnMKZTPOfgM5-fEyoYbw",
          height: 3_362_200
        })
    end

    test "with an error removing a hash" do
      {:error, [chain_id: :invalid]} =
        Cut.new()
        |> Cut.add_hash(1, %{
          hash: "CK2XPSueEx8EdkIehFMUadEBnMKZTPOfgM5-fEyoYbw",
          height: 3_362_200
        })
        |> Cut.remove_hash(25)
    end

    test "with and invalid origin id" do
      origin_invalid = %{
        id: nil,
        address: %{
          hostname: "hetzner-eu-13-58.poolmon.net",
          port: 4443
        }
      }

      {:error, [id: :not_a_string]} = Cut.set_origin(Cut.new(), origin_invalid)
    end

    test "with and invalid origin address hostname" do
      origin_invalid = %{
        id: "VsCK48567Tu5v4NucnGiB7Wp6QSf2K2UjiBbxW_XSgE",
        address: %{
          hostname: ["hetzner-eu-13-58.poolmon.net"],
          port: 4443
        }
      }

      {:error, [address: :invalid]} = Cut.set_origin(Cut.new(), origin_invalid)
    end

    test "with and invalid origin address port" do
      origin_invalid = %{
        id: "VsCK48567Tu5v4NucnGiB7Wp6QSf2K2UjiBbxW_XSgE",
        address: %{
          hostname: "hetzner-eu-13-58.poolmon.net",
          port: -10
        }
      }

      {:error, [address: :invalid]} = Cut.set_origin(Cut.new(), origin_invalid)
    end

    test "with an invalid height" do
      {:error, [height: :not_an_integer]} = Cut.set_height(Cut.new(), "invalid")
    end

    test "with an invalid weight" do
      {:error, [weight: :not_a_string]} = Cut.set_weight(Cut.new(), 1234)
    end

    test "with invalid origin" do
      {:error, [origin: :not_a_map]} = Cut.set_origin(Cut.new(), "invalid")
    end

    test "with invalid id" do
      {:error, [id: :not_a_string]} = Cut.set_id(Cut.new(), 1234)
    end

    test "with an invalid instance" do
      {:error, [instance: :not_a_string]} = Cut.set_instance(Cut.new(), 1234)
    end
  end
end
