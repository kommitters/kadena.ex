defmodule Kadena.Chainweb.Resources.FakeResource do
  @moduledoc false

  defstruct [:id, :status, :value, :extra_values]
end

defmodule Kadena.Chainweb.Resources.FakeValue do
  @moduledoc false

  defstruct [:literal]

  def new(literal) do
    %__MODULE__{
      literal: literal
    }
  end
end

defmodule Kadena.Chainweb.MappingTest do
  use ExUnit.Case

  alias Kadena.Chainweb.Resources.{FakeResource, FakeValue}
  alias Kadena.Chainweb.Mapping

  setup do
    %{
      attrs: %{
        "id" => "123",
        "status" => "success",
        "value" => 1,
        "extra_values" => [
          "extra1",
          "extra2"
        ]
      },
      resource: %FakeResource{}
    }
  end

  test "build/2", %{
    resource: resource,
    attrs:
      %{
        "id" => id,
        "status" => status,
        "value" => value,
        "extra_values" => extra_values
      } = attrs
  } do
    %FakeResource{
      id: ^id,
      status: ^status,
      value: ^value,
      extra_values: ^extra_values
    } = Mapping.build(resource, attrs)
  end

  test "build/2 empty_attrs", %{resource: resource} do
    %FakeResource{
      id: nil,
      status: nil,
      value: nil,
      extra_values: nil
    } = Mapping.build(resource, %{})
  end

  test "build/2 extra_attrs", %{
    resource: resource,
    attrs:
      %{
        "id" => id,
        "status" => status,
        "value" => value,
        "extra_values" => extra_values
      } = attrs
  } do
    attrs = Map.put(attrs, "extra_key", "extra_value")

    %FakeResource{
      id: ^id,
      status: ^status,
      value: ^value,
      extra_values: ^extra_values
    } = Mapping.build(resource, attrs)
  end

  test "parse/2", %{
    resource: resource,
    attrs:
      %{
        "id" => id
      } = attrs
  } do
    %FakeResource{
      id: ^id,
      status: :success,
      value: %FakeValue{literal: 1},
      extra_values: [
        %FakeValue{literal: "extra1"},
        %FakeValue{literal: "extra2"}
      ]
    } =
      resource
      |> Mapping.build(attrs)
      |> Mapping.parse(
        status: :atom,
        value: {:struct, FakeValue},
        extra_values: {:list, :struct, FakeValue}
      )
  end

  test "parse/2 atom", %{resource: resource, attrs: attrs} do
    %FakeResource{status: :success} =
      resource
      |> Mapping.build(attrs)
      |> Mapping.parse(status: :atom)
  end

  test "parse/2 map", %{resource: resource} do
    attrs = %{
      "value" => %{
        "number" => 1,
        "pact_value" => 1
      }
    }

    %FakeResource{
      value: %{"number" => 1, "pact_value" => %FakeValue{literal: 1}}
    } =
      resource
      |> Mapping.build(attrs)
      |> Mapping.parse(value: {:map, [{"pact_value", {:struct, FakeValue}}]})
  end

  test "parse/2 struct", %{resource: resource, attrs: attrs} do
    %FakeResource{value: %FakeValue{literal: 1}} =
      resource
      |> Mapping.build(attrs)
      |> Mapping.parse(value: {:struct, FakeValue})
  end

  test "parse/2 struct_nil", %{resource: resource, attrs: attrs} do
    attrs = Map.put(attrs, "value", nil)

    %FakeResource{value: nil} =
      resource
      |> Mapping.build(attrs)
      |> Mapping.parse(value: {:struct, PactValue})
  end

  test "parse/2 list_of_structs", %{resource: resource, attrs: attrs} do
    %FakeResource{extra_values: [%FakeValue{literal: "extra1"}, %FakeValue{literal: "extra2"}]} =
      resource
      |> Mapping.build(attrs)
      |> Mapping.parse(extra_values: {:list, :struct, FakeValue})
  end

  test "parse/2 list_of_maps", %{resource: resource} do
    attrs = %{
      "extra_values" => [
        %{
          "number" => 1,
          "pact_value" => 1
        },
        %{
          "number" => 2,
          "pact_value" => 2
        }
      ]
    }

    %FakeResource{
      extra_values: [
        %{"number" => 1, "pact_value" => %FakeValue{literal: 1}},
        %{"number" => 2, "pact_value" => %FakeValue{literal: 2}}
      ]
    } =
      resource
      |> Mapping.build(attrs)
      |> Mapping.parse(extra_values: {:list, :map, [{"pact_value", {:struct, FakeValue}}]})
  end
end
