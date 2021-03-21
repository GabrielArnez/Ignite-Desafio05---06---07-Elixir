defmodule Flightex.Bookings.BookingTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Bookings.Booking

  describe "build/4" do
    test "returns an booking when all params are valid" do
      booking = build(:booking)

      assert {:ok, _booking} =
               Booking.build(
                 booking.data_completa,
                 booking.cidade_origem,
                 booking.cidade_destino,
                 booking.id_usuario
               )
    end

    test "returns an error when there is an invalid date" do
      response = Booking.build(12345, "Araras", "Limeira", "00000-00-00000-0")

      expected_response = {:error, "Invalid date, the format must be 'yyyy-mm-dd hh:mm:ss'"}

      assert response == expected_response
    end
  end
end
