defmodule Kadena.Chainweb.Pact.Resources.ContinuationTest do
  @moduledoc """
  `Continuation` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Pact.Resources.Continuation

  alias Kadena.Types.{
    PactDecimal,
    PactInt,
    PactValue,
    PactValuesList
  }

  setup do
    %{
      attrs: %{
        "def" => "coin",
        "args" => "pact_value"
      }
    }
  end

  test "new/1 with args as string", %{attrs: attrs} do
    %Continuation{
      args: %PactValue{literal: "pact_value"},
      def: "coin"
    } = Continuation.new(attrs)
  end

  test "new/1 with args as integer", %{attrs: attrs} do
    attrs = Map.put(attrs, "args", 1)

    %Continuation{
      args: %PactValue{literal: 1},
      def: "coin"
    } = Continuation.new(attrs)
  end

  test "new/1 with args as integer not in range", %{attrs: attrs} do
    attrs = Map.put(attrs, "args", 9_007_199_254_740_992)

    %Continuation{
      args: %PactValue{
        literal: %PactInt{
          raw_value: 9_007_199_254_740_992,
          value: "9007199254740992"
        }
      },
      def: "coin"
    } = Continuation.new(attrs)
  end

  test "new/1 with args as float", %{attrs: attrs} do
    attrs = Map.put(attrs, "args", 0.01)
    decimal = Decimal.new("0.01")

    %Continuation{
      args: %PactValue{literal: ^decimal},
      def: "coin"
    } = Continuation.new(attrs)
  end

  test "new/1 with args as string decimal", %{attrs: attrs} do
    attrs = Map.put(attrs, "args", "9007199254740992.553")
    decimal = Decimal.new("9007199254740992.553")

    %Continuation{
      args: %PactValue{
        literal: %PactDecimal{
          raw_value: ^decimal,
          value: "9007199254740992.553"
        }
      },
      def: "coin"
    } = Continuation.new(attrs)
  end

  test "new/1 with args as boolean", %{attrs: attrs} do
    attrs = Map.put(attrs, "args", true)

    %Continuation{
      args: %PactValue{literal: true},
      def: "coin"
    } = Continuation.new(attrs)
  end

  test "new/1 with args as list", %{attrs: attrs} do
    attrs = Map.put(attrs, "args", ["COIN.gas", 0.01])
    decimal = Decimal.new("0.01")

    %Continuation{
      args: %PactValue{
        literal: %PactValuesList{
          pact_values: [
            %PactValue{literal: "COIN.gas"},
            %PactValue{literal: ^decimal}
          ]
        }
      },
      def: "coin"
    } = Continuation.new(attrs)
  end
end
