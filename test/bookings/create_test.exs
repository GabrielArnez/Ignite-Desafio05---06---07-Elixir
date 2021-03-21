defmodule Flightex.Bookings.CreateTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Create
  alias Flightex.Users.Agent, as: UserAgent

  describe("call/2") do
    setup do
      BookingAgent.start_link(%{})
      UserAgent.start_link(%{})

      {:ok, user_id} =
        build(:user)
        |> UserAgent.save()

      booking = build(:booking)

      {:ok, user_id: user_id, booking: booking}
    end

    test "saves the booking when all params are valid", %{user_id: user_id, booking: booking} do
      response =
        Create.call(user_id, %{
          data_completa: booking.data_completa,
          cidade_origem: booking.cidade_origem,
          cidade_destino: booking.cidade_destino
        })

      assert {:ok, _uuid} = response
    end

    test "returns an error when there is no user with given id", %{booking: booking} do
      response =
        Create.call("0000-000-000-0", %{
          data_completa: booking.data_completa,
          cidade_origem: booking.cidade_origem,
          cidade_destino: booking.cidade_destino
        })

      expected_response = {:error, "User not found"}

      assert response == expected_response
    end

    test "returns an error when there is an invalid date", %{user_id: user_id, booking: booking} do
      response =
        Create.call(user_id, %{
          data_completa: "00/00/0000",
          cidade_origem: booking.cidade_origem,
          cidade_destino: booking.cidade_destino
        })

      expected_response = {:error, "Invalid date, the format must be 'yyyy-mm-dd hh:mm:ss'"}

      assert response == expected_response
    end
  end
end
