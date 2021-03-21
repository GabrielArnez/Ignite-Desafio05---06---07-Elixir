defmodule Flightex.Users.CreateTest do
  use ExUnit.Case

  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.Create

  describe("call/1") do
    setup do
      UserAgent.start_link(%{})

      :ok
    end

    test "saves the user when all params are valid" do
      params = %{
        name: "Gideon Fernandes",
        email: "gideon@gmail.com",
        cpf: "12345678900"
      }

      assert {:ok, _uuid} = Create.call(params)
    end

    test "returns an error when there are invalid params" do
      params = %{
        name: "Gideon Fernandes",
        email: "gideon@gmail.com",
        cpf: 12_345_678_900
      }

      response = Create.call(params)

      expected_response = {:error, "Invalid parameters"}

      assert response == expected_response
    end
  end
end
