defmodule Flightex.Users.UserTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Users.User

  describe "build/3" do
    test "returns an user when all params are valid" do
      user = build(:user)

      assert {:ok, _user} = User.build(user.name, user.email, user.cpf)
    end

    test "returns an error when there are invalid params" do
      response = User.build("Gideon Fernandes", "gideon@gmail.com", 12_345_678_900)

      expected_response = {:error, "Invalid parameters"}

      assert response == expected_response
    end
  end
end
