defmodule Kadena.Chainweb.Client.CannedCutRequests do
  @moduledoc false

  alias Kadena.Chainweb.Error
  alias Kadena.Test.Fixtures.Chainweb

  def request(
        :get,
        "https://api.chainweb.com/chainweb/0.0/mainnet01/cut",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("cut")
    {:ok, response}
  end

  def request(
        :get,
        "https://us2.testnet.chainweb.com/chainweb/0.0/testnet04/cut",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("cut_location")
    {:ok, response}
  end

  def request(
        :get,
        "https://jp2.chainweb.com/chainweb/0.0/mainnet01/cut?maxheight=36543",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("cut_with_max_height")
    {:ok, response}
  end

  def request(
        :get,
        "https://api.chainweb.com/chainweb/0.0/mainnet01/cut?maxheight=f",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title:
             "Error parsing query parameter maxheight failed: could not parse: `f' (input does not start with a digit)"
         }}
      )

    {:error, response}
  end

  def request(
        :get,
        "https://col1.chainweb.com/chainweb/0.0/mainnet01/cut",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: :network_error,
           title: :nxdomain
         }}
      )

    {:error, response}
  end

  def request(
        :put,
        "https://us1.testnet.chainweb.com/chainweb/0.0/testnet04/cut",
        _headers,
        _body,
        _options
      ) do
    response = %{response: :no_content, status: 204}
    {:ok, response}
  end

  def request(
        :put,
        "https://us-e2.chainweb.com/chainweb/0.0/mainnet01/cut",
        _headers,
        body,
        _options
      ) do
    body |> Jason.decode!() |> return_response()
  end

  def request(
        :put,
        "https://col1.chainweb.com/chainweb/0.0/mainnet01/cut",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: :network_error,
           title: :nxdomain
         }}
      )

    {:error, response}
  end

  def return_response(%{"origin" => nil}) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title: "Cut is missing an origin entry"
         }}
      )

    {:error, response}
  end

  def return_response(%{"origin" => origin}) when origin == %{} do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title: "Error in $.origin: key \"id\" not found"
         }}
      )

    {:error, response}
  end

  def return_response(_body) do
    response = %{response: :no_content, status: 204}
    {:ok, response}
  end
end

defmodule Kadena.Chainweb.P2P.CutTest do
  @moduledoc """
  `Cut` endpoints implementation tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb
  alias Kadena.Chainweb.Client.CannedCutRequests
  alias Kadena.Chainweb.P2P.{Cut, CutResponse}

  describe "retrieve/1" do
    setup do
      Application.put_env(:kadena, :http_client_impl, CannedCutRequests)

      on_exit(fn ->
        Application.delete_env(:kadena, :http_client_impl)
      end)

      response =
        {:ok,
         %CutResponse{
           cut: %Chainweb.Cut{
             hashes: %{
               "12": %{height: 3_350_810, hash: "AhycH3_Cm5vNhJDpIbWZCiQnf8gpBuFJMXia9IWiyhY"},
               "13": %{height: 3_350_810, hash: "T53jWSF7ptv4nhLLA6bMkRYarUN7mXFvJYDoj10WUwo"},
               "14": %{height: 3_350_810, hash: "R-V3KEhCjRlPSADuyTH7BO_yl4Czoaexi9z3wn9PvKQ"},
               "15": %{height: 3_350_810, hash: "JOyEl16czTUdjKaQ87UPSHEhYVjJbjxE6iuVmQqmWY4"},
               "8": %{height: 3_350_811, hash: "IuLhkJPxnXMTxS-yqdiiZycrO8TuWRLADSKU6gF0Xq0"},
               "9": %{height: 3_350_810, hash: "rBfNt0ko6NKapKcUF0GVPpvHljWC7REwWSQK6sDsM3o"},
               "10": %{height: 3_350_811, hash: "BAREvbDGlwIAd25-07Wsy9Bie4X4iRQoY7gZ20hKymo"},
               "11": %{height: 3_350_811, hash: "R4tkV9ll3cWQMk8EhncGtnBxNNA7bmqEySBpRlrFUUA"},
               "4": %{height: 3_350_811, hash: "oL5e3o3N-TFasjG74M5Mdt0DDh0Q_bIvnK1vlSuymTY"},
               "5": %{height: 3_350_810, hash: "YdCa2qi0mzXkXhm2nY1Wvva8R6wp0Hf5_v40bcubIxs"},
               "6": %{height: 3_350_811, hash: "Vpq2SBUmd8pwuGp62OkgmD6KH6lPnOZNtUo050LKZ1w"},
               "7": %{height: 3_350_811, hash: "MG9tHsLGYfl3RwvdAIeS4rMqyxaagCBSOuNx7hrhKSA"},
               "0": %{height: 3_350_810, hash: "MTqXrZQ7qZ7R-mfVrFjic44gKnGSXmBvfbw_wsfa9RI"},
               "16": %{height: 3_350_810, hash: "2gPywfZJxcCeHOE8x7zbPzilX0vxCtrjNNKW-qX0VaA"},
               "1": %{height: 3_350_810, hash: "R4OJy6BhVh3QvTL9ZOVN2hiYL92RlkK6qIbd3Lh9dVk"},
               "17": %{height: 3_350_810, hash: "x-HA372GM7YLteTIsyoONqsJs9mQHg8pf1sP8SplOa8"},
               "2": %{height: 3_350_810, hash: "62GIrxarXRjJatrvo5HxsCxydTaCzl85bd8pB0CFLQ8"},
               "18": %{height: 3_350_810, hash: "LEFgHmu82fvMq6y_gGXmZJYp5b0-v00mH945t7MY2QM"},
               "3": %{height: 3_350_811, hash: "wVbYjTs0GK0JbpIyMNDwQoHjVLooJnqSBCoe2sdbsNQ"},
               "19": %{height: 3_350_811, hash: "t29Iw-IePODh8l2pd4L2BTylEbGqkjMY7P8JP5kHMHQ"}
             },
             origin: nil,
             weight: "ZB92Nn9_T2nN5wMAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
             height: 67_016_208,
             instance: "mainnet01",
             id: "BsoV-rBBDF6caxH25NTBpyUoPtsYeLxVW4aG4_ZMjuM"
           }
         }}

      location_response =
        {:ok,
         %CutResponse{
           cut: %Chainweb.Cut{
             hashes: %{
               "12": %{height: 2_879_143, hash: "ZoPyCmaPDFeUm_OoW7bhntzSlX5KOp55eu0BKbO0jyQ"},
               "13": %{
                 height: 2_879_143,
                 hash: "6n30wlO6FCakuo3veUMYwbSA4JPOSZDIqetMaXEf_A4"
               },
               "14": %{height: 2_879_143, hash: "SfpB4QjJzfPKQ33yCFjDY7pC8VMXXZh0-MuSL_Ly71g"},
               "15": %{height: 2_879_143, hash: "apvFpOShJ9ZaDLFvQZdZIwyLMHw0NjD5CbJcLTdWW6M"},
               "8": %{height: 2_879_143, hash: "rUmkSkjNakGTBUSeti-D3tUpQYZw0y9J8zxaev5oGyc"},
               "9": %{height: 2_879_143, hash: "RoXFTH5jhLOHOLgycHo0RWiPbDo4u9-Wy4T2RDDhmsA"},
               "10": %{height: 2_879_144, hash: "lnMd7Uc28DQrAf3LNShQh3H0az8kBdJsuvhzgpNlcaU"},
               "11": %{height: 2_879_143, hash: "N2eNbHjzdnCSaNqPMn3ClSNQimfOaXiQeIv2W2ljOJg"},
               "4": %{height: 2_879_143, hash: "AIQiMUTWC9JRvkk3BasXF5RGT3WY69CAPIy3FkrXn4E"},
               "5": %{height: 2_879_142, hash: "oDtvB34xTAOqVCvSc9PCU4m4Q9DSNHiVEClAM9ep9SE"},
               "6": %{height: 2_879_142, hash: "QZl4JnrjUTawVhdhxgQzmWg9Va3wBASlE3YQLjrA6W4"},
               "7": %{height: 2_879_143, hash: "cL6TmN5oEfhNQjGTjbP76MK12dyTaMwZUzxN8fDKxM4"},
               "0": %{height: 2_879_143, hash: "OXuK1aLRGop9B6lAGQ81BmlmIMrtujPlNjUFs1arlwU"},
               "16": %{height: 2_879_143, hash: "sACdosAU4ecPntjQv3SSYsJzkxvGgwZ5qO_36meVnH8"},
               "1": %{height: 2_879_143, hash: "aNkjqRCt32kS2Aeqi9CRzBeLgiRI3FtktRoa34YcEUw"},
               "17": %{height: 2_879_143, hash: "akoCaQWuyiv-HbEKa5_14A9H09t0AjofBTPr3XBLl_0"},
               "2": %{height: 2_879_143, hash: "5QiTTJxGFAE8YRzQ9xKG9f248f7BsKN61AlqhiPRggg"},
               "18": %{height: 2_879_143, hash: "Xn0K9oXjAzZWLq1j7G03i3zFotMGDuZkUMdwV5I8RQQ"},
               "3": %{height: 2_879_143, hash: "6XxPlqpmqQ0C1WvSPpWh6_DE1e6Tq4WYvQVE-nsSMOg"},
               "19": %{height: 2_879_143, hash: "8d6qrqmry9QC-ayDhECTR8DzF2lw6Cwqb27F0Cc2cnU"}
             },
             origin: nil,
             weight: "XMcE8a3DAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
             height: 57_582_859,
             instance: "testnet04",
             id: "l1Sk9q3MehCdXG9lxILJBkMMB5HTYMUUsBNMV6YIMaA"
           }
         }}

      query_response =
        {:ok,
         %CutResponse{
           cut: %Chainweb.Cut{
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
         }}

      max_height = 436_632

      %{
        response: response,
        location_response: location_response,
        query_response: query_response,
        max_height: max_height
      }
    end

    test "success", %{response: response} do
      ^response = Cut.retrieve(network_id: :mainnet01)
    end

    test "success with location", %{location_response: location_response} do
      ^location_response = Cut.retrieve(location: "us2", network_id: :testnet04)
    end

    test "success with location and query params", %{query_response: query_response} do
      ^query_response =
        Cut.retrieve(location: "jp2", network_id: :mainnet01, query_params: [maxheight: "36543"])
    end

    test "error not existing location" do
      {:error, %Chainweb.Error{status: :network_error, title: :nxdomain}} =
        Cut.retrieve(location: "col1", network_id: :mainnet01)
    end

    test "error query params" do
      {:error,
       %Chainweb.Error{
         status: 400,
         title:
           "Error parsing query parameter maxheight failed: could not parse: `f' (input does not start with a digit)"
       }} = Cut.retrieve(network_id: :mainnet01, query_params: [maxheight: "f"])
    end
  end

  describe "publish/3" do
    setup do
      Application.put_env(:kadena, :http_client_impl, CannedCutRequests)

      on_exit(fn ->
        Application.delete_env(:kadena, :http_client_impl)
      end)

      %{
        payload_testnet:
          Chainweb.Cut.new(
            hashes: %{
              "0": %{hash: "k4sSYR2YCV-lrXrGvtdxS0OMDIohqkMRHZtVn8EjxQw", height: 2_892_544},
              "1": %{hash: "M7JqlTZzkhtjU4XJrD4P61yD16DWB0vtBO_gxYF2NwY", height: 2_892_543},
              "10": %{hash: "KLQeGKKP5rDa2XTFKrBPjTywVh6WOtlCAlNEmGq_E8k", height: 2_892_544},
              "11": %{hash: "PB9q_J9T8H72L8jBWFrnv1UZ8akTLQAk4QE9qCgQdHs", height: 2_892_544},
              "12": %{hash: "4hIRfbY1hocV45oTwohdmgQcV19cI2TkJsvEaacFglQ", height: 2_892_545},
              "13": %{hash: "SxIZk18NB9U9UX1a5b3TC3zZW59thpQOVoPX-Uj7sXE", height: 2_892_544},
              "14": %{hash: "KID4GH2VhMdArpnZbTKLSqo8SzVWUEHSxjF0pitvkiI", height: 2_892_545},
              "15": %{hash: "m6Y65nMxkkIipzH_36cpe7ukNYM6QmyLq_5HbT12sM0", height: 2_892_545},
              "16": %{hash: "UBxAWvGZy_yhLhDGUMgMgbn8ygqOu3jm-cfpy4xCzkQ", height: 2_892_544},
              "17": %{hash: "r1aB7vEQUd6ivHihsWboPKBmffRH7ZdIbRt_LfZRJ6g", height: 2_892_545},
              "18": %{hash: "gpvZszjV_Zjmy6cVQEdiX4TEnHQ1oXUNRwSP7uYpkxA", height: 2_892_545},
              "19": %{hash: "gzZnNrZtwcDDZVYbSRkbf6CWtgDv4Gkm-zfnfMD6fxI", height: 2_892_544},
              "2": %{hash: "M64LSHud2DhtxMX35T8IDAzd66OGW-TM7utFYpEcZjU", height: 2_892_544},
              "3": %{hash: "s_-hack8xv2cdN6or0MCQM7djJbLyLB6_oML2kJ3Rms", height: 2_892_545},
              "4": %{hash: "e-_CWdiWIIvyrls1loiiBlnfFV0N5r1MCbIFbU9tuuI", height: 2_892_545},
              "5": %{hash: "0SZf0_jj7TLE9SICe8l5s441bIlSxRVu3--FFw3AdOk", height: 2_892_545},
              "6": %{hash: "BxGtGfY0rP-I4UPgvHfrRIm4MkqHBTDWIFPqwZ2tNPU", height: 2_892_544},
              "7": %{hash: "X0QUl32xZCtUvcseaTo1o8r2IgKqXrMAfdj4ctJg00U", height: 2_892_545},
              "8": %{hash: "SVTK2_PZtUslGKnlX2BmEw4ss8myLTeOTbtLzdNgUPw", height: 2_892_545},
              "9": %{hash: "gtZ6-HnkLOIO-Kwt9Pdfj2V38IDMcqbhsQMRpFBG2-0", height: 2_892_545}
            },
            height: 57_850_890,
            id: "NiuWkgQIjlepKcJ_1_37SD32PI61aNHhxTIVNJQf0LA",
            instance: "testnet04",
            origin: %{
              id: "SMS0rJlkg59bwR9Vm0HlZGsBjyt56rJtSD5DXzd_r0g",
              address: %{
                hostname: "139.144.77.27",
                port: 1788
              }
            },
            weight: "v-oSR4rGAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
          ),
        payload_mainnet:
          Chainweb.Cut.new(
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
            origin: %{
              id: "VsCK48567Tu5v4NucnGiB7Wp6QSf2K2UjiBbxW_XSgE",
              address: %{
                hostname: "hetzner-eu-13-58.poolmon.net",
                port: 4443
              }
            },
            weight: "zrmhnWgsJ-5v9gMAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
          ),
        payload_with_nil_origin:
          Chainweb.Cut.new(
            hashes: %{
              "0": %{hash: "N5oyYlCvq6VvyoqioTQClWXAudf_ap3gqXxSpr4V32w", height: 3_362_200},
              "1": %{hash: "CK2XPSueEx8EdkIehFMUadEBnMKZTPOfgM5-fEyoYbw", height: 3_362_200}
            },
            height: 67_243_992,
            id: "PXbSJgmFjN3A4DSz37ttYWmyrpDfzCoyivVflV3VL9A",
            instance: "mainnet01",
            origin: nil,
            weight: "zrmhnWgsJ-5v9gMAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
          ),
        payload_with_empty_origin:
          Chainweb.Cut.new(
            hashes: %{
              "0": %{hash: "N5oyYlCvq6VvyoqioTQClWXAudf_ap3gqXxSpr4V32w", height: 3_362_200},
              "1": %{hash: "CK2XPSueEx8EdkIehFMUadEBnMKZTPOfgM5-fEyoYbw", height: 3_362_200}
            },
            height: 67_243_992,
            id: "PXbSJgmFjN3A4DSz37ttYWmyrpDfzCoyivVflV3VL9A",
            instance: "mainnet01",
            origin: %{},
            weight: "zrmhnWgsJ-5v9gMAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
          )
      }
    end

    test "success", %{payload_mainnet: payload_mainnet} do
      {:ok, %CutResponse{cut: ^payload_mainnet}} =
        Cut.publish(payload_mainnet,
          location: "us-e2",
          network_id: :mainnet01
        )
    end

    test "success with only required args", %{payload_testnet: payload_testnet} do
      {:ok, %CutResponse{cut: ^payload_testnet}} = Cut.publish(payload_testnet)
    end

    test "error with an nil origin", %{payload_with_nil_origin: payload_with_nil_origin} do
      {:error, %Chainweb.Error{status: 400, title: "Cut is missing an origin entry"}} =
        Cut.publish(payload_with_nil_origin, location: "us-e2", network_id: :mainnet01)
    end

    test "error with an empty origin", %{payload_with_empty_origin: payload_with_empty_origin} do
      {:error, %Chainweb.Error{status: 400, title: "Error in $.origin: key \"id\" not found"}} =
        Cut.publish(payload_with_empty_origin, location: "us-e2", network_id: :mainnet01)
    end

    test "error with a non existing location", %{payload_mainnet: payload_mainnet} do
      {:error, %Chainweb.Error{status: :network_error, title: :nxdomain}} =
        Cut.publish(payload_mainnet, location: "col1", network_id: :mainnet01)
    end
  end
end
