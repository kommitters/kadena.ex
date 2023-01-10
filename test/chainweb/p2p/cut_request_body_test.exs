defmodule Kadena.Chainweb.P2P.CutRequestBodyTest do
  @moduledoc """
  `CutRequestBody` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.P2P.{CutRequestBody, CutResponse}

  setup do
    cut_response = %CutResponse{
      hashes: %{
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
      },
      height: 67_243_992,
      id: "PXbSJgmFjN3A4DSz37ttYWmyrpDfzCoyivVflV3VL9A",
      instance: "mainnet01",
      origin: nil,
      weight: "zrmhnWgsJ-5v9gMAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    }

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

    %{
      cut_response: cut_response,
      hashes: hashes,
      height: 67_243_992,
      id: "PXbSJgmFjN3A4DSz37ttYWmyrpDfzCoyivVflV3VL9A",
      instance: "mainnet01",
      weight: "zrmhnWgsJ-5v9gMAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    }
  end

  describe "new/1" do
    test "with valid params", %{
      cut_response: cut_response,
      hashes: hashes,
      height: height,
      id: id,
      instance: instance,
      weight: weight
    } do
      %CutRequestBody{
        hashes: ^hashes,
        height: ^height,
        id: ^id,
        instance: ^instance,
        origin: nil,
        weight: ^weight
      } = CutRequestBody.new(cut_response)
    end

    test "with an invalid no list params" do
      {:error, [payload: :not_a_cut_response]} = CutRequestBody.new("No list")
    end
  end

  describe "set_origin/2" do
    setup do
      cut_response = %CutResponse{
        hashes: %{
          "0": %{hash: "zkkjtWjiD68BcaISzjn5_y7-vQ3Yk2y3swhz7hm_7w8", height: 3654},
          "1": %{hash: "M-tbkEAVpS0-v5dxu-rxhRkjcVZfSE1nKEBBxNvka_g", height: 3654},
          "2": %{hash: "af5hWh0dUJoTGr5Bn8JxgDbAA97h6uqtclYi4SP95w8", height: 3654},
          "3": %{hash: "1-XVBn9NO2-g53WFzX9YpYT-t10Rr3RWJTdydMxK7Qg", height: 3654},
          "4": %{hash: "wphlMRCrkjVaIBlFNQdlTonLxGRebClL4DTHjZhgpXw", height: 3654},
          "5": %{hash: "T6iaDkYwzMBIBEyXgkFQ-T4FMhS__g6DACs4C8O27gg", height: 3654},
          "6": %{hash: "fX3NieTI5CjMs9VZEyfRqHg0B3ZKyxNkm7-p4TIfSZ4", height: 3654},
          "7": %{hash: "ddZN5o0ZNrcgmCOaEhyWb0rmpl0QcBguwfmop6uQKpI", height: 3654},
          "8": %{hash: "KEQkdXVF0nYujH43U0q-nkwDIUViZnncWol78Spoxow", height: 3654},
          "9": %{hash: "qqCoe3VfCyH6vJmn22RLIzD8DrDrKKjKlPn15UQ25TU", height: 3654}
        },
        height: 36_540,
        id: "DeYKC0r8tXxZRYyx-S49sVzFCAZ8TZT3J1UlVSVmjCA",
        instance: "mainnet01",
        origin: nil,
        weight: "LKml1d8BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
      }

      cut_request_body = CutRequestBody.new(cut_response)

      origin = %{
        id: "VsCK48567Tu5v4NucnGiB7Wp6QSf2K2UjiBbxW_XSgE",
        address: %{
          hostname: "hetzner-eu-13-58.poolmon.net",
          port: 4443
        }
      }

      %{
        origin: origin,
        cut_request_body: cut_request_body
      }
    end

    test "with an origin map", %{cut_request_body: cut_request_body, origin: origin} do
      %CutRequestBody{origin: ^origin} = CutRequestBody.set_origin(cut_request_body, origin)
    end

    test "with nil origin", %{cut_request_body: cut_request_body} do
      %CutRequestBody{origin: nil} = CutRequestBody.set_origin(cut_request_body, nil)
    end
  end

  describe "JSONPayload.to_json!/1" do
    setup do
      %{
        json_result:
          "{\"hashes\":{\"0\":{\"hash\":\"N5oyYlCvq6VvyoqioTQClWXAudf_ap3gqXxSpr4V32w\",\"height\":3362200},\"1\":{\"hash\":\"CK2XPSueEx8EdkIehFMUadEBnMKZTPOfgM5-fEyoYbw\",\"height\":3362200},\"10\":{\"hash\":\"96YYw5pRg4MBjkNFDl9Xp7jHbOnagJMj7X5dCqZ60XU\",\"height\":3362200},\"11\":{\"hash\":\"pFUCltdbMKaPNIbD5UmYPOlI39JGPKB5btukDg0UDu4\",\"height\":3362199},\"12\":{\"hash\":\"DUmXlz012BHJ4E_yrer4KreqjJLFbt9MBshgJ_et6TA\",\"height\":3362200},\"13\":{\"hash\":\"FjR3WBYQDaDvSiiq56gyV71DZrBiu83zupTbfBG_-ig\",\"height\":3362199},\"14\":{\"hash\":\"gmNKndByH1bTC-3Ta_v387x1E-7esY9Vn3vYPcWr-vw\",\"height\":3362200},\"15\":{\"hash\":\"jFrXJGikDL71aLn4g6HP4hDQKWQFYSIFjdca4__pu2c\",\"height\":3362200},\"16\":{\"hash\":\"WEVmzdin0Rb5WAlYczcIWOFtyzSZQosVFGaqbhbQ-N8\",\"height\":3362200},\"17\":{\"hash\":\"GBOnwWBFpKzMRbfixDwWTMcM2ViLld0EAVdnmgWsbx8\",\"height\":3362200},\"18\":{\"hash\":\"-B6DtXsobMyJ2kQHr60CHMskur6pA7snFu140Utiyzk\",\"height\":3362199},\"19\":{\"hash\":\"dWJGDWMSqqHiTjKKKPlSTegNqF3oGFURslo43hs-WtM\",\"height\":3362200},\"2\":{\"hash\":\"Mh2UjcEWgqYoyueYlq2tGa136cq3V4OOg7bmYHdfebI\",\"height\":3362200},\"3\":{\"hash\":\"rzXbneFCATH1XTPbCrGlFBFQGkKV5PNzOW7F2IRiCsE\",\"height\":3362198},\"4\":{\"hash\":\"SMDq8UsGZBR1JL9uiPIjzWgqzQg0uGB2QhmgJb3nt7k\",\"height\":3362200},\"5\":{\"hash\":\"WlkYOwmc8ToRsPb6RBl814R-RdhpL4rw5sBbW98d414\",\"height\":3362199},\"6\":{\"hash\":\"khQSsOZvKQCickhbp19ovrpIQNYQgCc9oAJ2veSxt6c\",\"height\":3362199},\"7\":{\"hash\":\"EdsyQ0S5O1zNYZ5TBS7VnwstBwaaSFoWR1JSaLt6ESU\",\"height\":3362200},\"8\":{\"hash\":\"9eexjG99ScAoMkxrEmtVPAMEis0ZsY_05ZBVyj1hdP8\",\"height\":3362199},\"9\":{\"hash\":\"uAB0hM5bNmvXbtvuohcXH6DSX6bnZ3yGhdTJvvBYzC4\",\"height\":3362200}},\"height\":67243992,\"id\":\"PXbSJgmFjN3A4DSz37ttYWmyrpDfzCoyivVflV3VL9A\",\"instance\":\"mainnet01\",\"origin\":null,\"weight\":\"zrmhnWgsJ-5v9gMAAAAAAAAAAAAAAAAAAAAAAAAAAAA\"}"
      }
    end

    test "with a valid CutRequestBody", %{
      cut_response: cut_response,
      json_result: json_result
    } do
      ^json_result =
        cut_response
        |> CutRequestBody.new()
        |> CutRequestBody.to_json!()
    end
  end
end
