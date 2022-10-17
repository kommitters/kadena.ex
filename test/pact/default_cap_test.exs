defmodule Kadena.Pact.DefaultCapTest do
  @moduledoc """
  `Pact.Cap.Default` functions tests.
  """

  use ExUnit.Case

  alias Kadena.Pact.Cap
  alias Kadena.Types.Cap, as: CapStruct
  alias Kadena.Types.{PactValue, PactValuesList}

  describe "create_cap/2" do
    test "with a valid data" do
      decimal = Decimal.new("0.1")

      {:ok,
       %CapStruct{
         name: "coin.TRANSFER",
         args: %PactValuesList{
           pact_values: [
             %PactValue{literal: "fromAcctName"},
             %PactValue{literal: "toAcctName"},
             %PactValue{literal: ^decimal}
           ]
         }
       }} = Cap.create_cap("coin.TRANSFER", ["fromAcctName", "toAcctName", 0.1])
    end

    test "with an invalid name" do
      {:error, [name: :invalid]} = Cap.create_cap(1, ["fromAcctName", "toAcctName", 0.1])
    end
  end
end
