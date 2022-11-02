defmodule Kadena.Utils.MapCaseTest do
  @moduledoc """
  `Utils.MapCase` functions tests.
  """

  use ExUnit.Case

  alias Kadena.Utils.MapCase

  describe "to_camel/1" do
    setup do
      decimal = Decimal.new("0.54")

      %{
        snake_map: %{
          hi_world: :hello_world,
          snake_map: %{list: [%{first_map: "valid_map"}, :valid, %{second_map: "second_map"}]},
          atom: :valid,
          decimal_value: decimal
        },
        expected_camel_map: %{
          "hiWorld" => :hello_world,
          "snakeMap" => %{
            "list" => [%{"firstMap" => "valid_map"}, :valid, %{"secondMap" => "second_map"}]
          },
          "atom" => :valid,
          "decimalValue" => decimal
        }
      }
    end

    test "with a snake map", %{snake_map: snake_map, expected_camel_map: expected_camel_map} do
      ^expected_camel_map = MapCase.to_camel!(snake_map)
    end

    test "with a valid snake map", %{snake_map: snake_map, expected_camel_map: expected_camel_map} do
      {:ok, ^expected_camel_map} = MapCase.to_camel(snake_map)
    end

    test "with a empty snake map" do
      {:ok, %{}} = MapCase.to_camel(%{})
    end
  end

  describe "to_snake/1" do
    setup do
      decimal = Decimal.new("0.54")

      %{
        camel_map: %{
          hiWorld: :hello_world,
          snakeMap: %{list: [%{firstMap: "valid_map"}, :valid, %{secondMap: "second_map"}]},
          atom: :valid,
          decimalValue: decimal
        },
        expected_snake_map: %{
          "hi_world" => :hello_world,
          "snake_map" => %{
            "list" => [%{"first_map" => "valid_map"}, :valid, %{"second_map" => "second_map"}]
          },
          "atom" => :valid,
          "decimal_value" => decimal
        }
      }
    end

    test "with a camelized map", %{camel_map: camel_map, expected_snake_map: expected_snake_map} do
      ^expected_snake_map = MapCase.to_snake!(camel_map)
    end

    test "with a valid camelized map", %{
      camel_map: camel_map,
      expected_snake_map: expected_snake_map
    } do
      {:ok, ^expected_snake_map} = MapCase.to_snake(camel_map)
    end

    test "with an empty map" do
      {:ok, %{}} = MapCase.to_snake(%{})
    end
  end
end
