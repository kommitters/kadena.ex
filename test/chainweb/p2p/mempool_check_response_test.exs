defmodule Kadena.Chainweb.P2P.MempoolCheckResponseTest do
  @moduledoc """
  MempoolCheckResponse struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.P2P.MempoolCheckResponse

  setup do
    %{
      attrs: [true, false],
      results: [true, false]
    }
  end

  test "new/1", %{
    attrs: attrs,
    results: results
  } do
    %MempoolCheckResponse{results: ^results} = MempoolCheckResponse.new(attrs)
  end
end
