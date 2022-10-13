defmodule Kadena.Types.SigningCapTest do
  @moduledoc """
  `SigningCap` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Cap, SigningCap}

  describe "new/1" do
    setup do
      cap_list = [name: "gas", args: ["COIN.gas", 1.0e-2]]

      %{
        role: "",
        description: "",
        cap: cap_list,
        cap_struct: Cap.new(cap_list)
      }
    end

    test "with a valid param list", %{
      role: role,
      description: description,
      cap: cap,
      cap_struct: cap_struct
    } do
      %SigningCap{role: ^role, description: ^description, cap: ^cap_struct} =
        SigningCap.new(role: role, description: description, cap: cap)
    end

    test "with a valid cap struct", %{
      role: role,
      description: description,
      cap_struct: cap_struct
    } do
      %SigningCap{role: ^role, description: ^description, cap: ^cap_struct} =
        SigningCap.new(role: role, description: description, cap: cap_struct)
    end

    test "with an invalid params list" do
      {:error, [signing_cap: :not_a_list]} = SigningCap.new("invalid_param")
    end

    test "with an invalid role", %{
      description: description,
      cap_struct: cap_struct
    } do
      {:error, [role: :invalid]} =
        SigningCap.new(role: 123, description: description, cap: cap_struct)
    end

    test "with an invalid description", %{role: role, cap_struct: cap_struct} do
      {:error, [description: :invalid]} =
        SigningCap.new(role: role, description: 123, cap: cap_struct)
    end

    test "with an invalid cap list", %{
      role: role,
      description: description
    } do
      {:error, [cap: :invalid, name: :invalid]} =
        SigningCap.new(role: role, description: description, cap: [invalid_key: :invalid_value])
    end

    test "with a no list cap", %{
      role: role,
      description: description
    } do
      {:error, [cap: :invalid, args: :invalid]} =
        SigningCap.new(role: role, description: description, cap: :invalid_value)
    end
  end
end
