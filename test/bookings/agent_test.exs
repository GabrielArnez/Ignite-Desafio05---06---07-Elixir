defmodule Flightex.Bookings.AgentTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Bookings.Agent, as: BookingAgent

  describe("save/1") do
    test "saves the booking" do
      BookingAgent.start_link(%{})

      booking = build(:booking)

      assert {:ok, _uuid} = BookingAgent.save(booking)
    end
  end

  describe("get/1") do
    setup do
      BookingAgent.start_link(%{})

      :ok
    end

    test "returns the booking when the booking is found" do
      {:ok, uuid} =
        :booking
        |> build()
        |> BookingAgent.save()

      assert {:ok, _booking} = BookingAgent.get(uuid)
    end

    test "returns an error if the user is not found" do
      response = BookingAgent.get("00000000000")

      expected_response = {:error, "Flight Booking not found"}

      assert response == expected_response
    end
  end
end
