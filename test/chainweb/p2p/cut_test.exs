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
end

defmodule Kadena.Chainweb.P2P.CutTest do
  @moduledoc """
  `Cut` endpoint implementation tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Client.CannedCutRequests
  alias Kadena.Chainweb.Error
  alias Kadena.Chainweb.P2P.{Cut, CutResponse}

  setup do
    Application.put_env(:kadena, :http_client_impl, CannedCutRequests)

    on_exit(fn ->
      Application.delete_env(:kadena, :http_client_impl)
    end)

    %{
      max_height: 436_632,
      response:
        {:ok,
         %CutResponse{
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
         }},
      location_response:
        {:ok,
         %CutResponse{
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
         }},
      query_response:
        {:ok,
         %CutResponse{
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
         }}
    }
  end

  test "retrieve/1", %{response: response} do
    ^response = Cut.retrieve(network_id: :mainnet01)
  end

  test "retrieve/1 with location", %{location_response: location_response} do
    ^location_response = Cut.retrieve(location: "us2", network_id: :testnet04)
  end

  test "retrieve/1 with location and query params", %{query_response: query_response} do
    ^query_response =
      Cut.retrieve(location: "jp2", network_id: :mainnet01, query_params: [maxheight: "36543"])
  end

  test "retrieve/2 not existing location error" do
    {:error, %Error{status: :network_error, title: :nxdomain}} =
      Cut.retrieve(location: "col1", network_id: :mainnet01)
  end

  test "retrieve/2 query params error" do
    {:error,
     %Error{
       status: 400,
       title:
         "Error parsing query parameter maxheight failed: could not parse: `f' (input does not start with a digit)"
     }} = Cut.retrieve(network_id: :mainnet01, query_params: [maxheight: "f"])
  end
end
