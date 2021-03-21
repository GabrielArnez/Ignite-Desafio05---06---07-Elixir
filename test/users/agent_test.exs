defmodule Flightex.Users.AgentTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Users.Agent, as: UserAgent

  describe("save/1") do
    test "saves the user" do
      UserAgent.start_link(%{})

      user = build(:user)

      assert {:ok, _uuid} = UserAgent.save(user)
    end
  end

  describe("get/1") do
    setup do
      UserAgent.start_link(%{})

      :ok
    end

    test "returns the user when the user is found" do
      {:ok, user_id} =
        :user
        |> build(name: "Jodie Conroy", email: "alfonzo.tromp@farrell.net", cpf: "12345678900")
        |> UserAgent.save()

      response = UserAgent.get(user_id)

      expected_response =
        {:ok,
         %Flightex.Users.User{
           name: "Jodie Conroy",
           email: "alfonzo.tromp@farrell.net",
           cpf: "12345678900"
         }}

      assert response == expected_response
    end

    test "returns an error if the user is not found" do
      response = UserAgent.get("0000-00000-00")

      expected_response = {:error, "User not found"}

      assert response == expected_response
    end
  end
end
