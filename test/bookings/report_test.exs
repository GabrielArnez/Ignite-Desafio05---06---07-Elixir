defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case

  import Flightex.Factory

  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking
  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Bookings.Report

  describe("create/2") do
    test "creates the report file by date range" do
      BookingAgent.start_link(%{})
      UserAgent.start_link(%{})

      {:ok, user_id} =
        build(:user)
        |> UserAgent.save()

      {:ok, booking} = Booking.build("2021-03-22 09:00:00", "Araras", "Limeira", user_id)
      BookingAgent.save(booking)

      {:ok, booking} = Booking.build("2021-03-27 15:00:00", "Piracicaba", "São Carlos", user_id)
      BookingAgent.save(booking)

      {:ok, booking} = Booking.build("2021-03-30 15:00:00", "Limeira", "Araras", user_id)
      BookingAgent.save(booking)

      create_response = Report.create("2021-03-21 00:00:00", "2021-03-27 15:00:00")
      read_response = File.read!("report.csv")

      response = {create_response, read_response}

      expected_response =
        {{:ok, "Report generated successfully"},
         "#{user_id},Araras,Limeira,2021-03-22 09:00:00\n" <>
           "#{user_id},Piracicaba,São Carlos,2021-03-27 15:00:00\n"}

      assert response == expected_response
    end

    test "returns an error when the dates provided are invalid" do
      response = Report.create("2021-03", "2021-03")

      expected_response = {:error, "Invalid date, the format must be 'yyyy-mm-dd hh:mm:ss'"}

      assert response == expected_response
    end
  end
end
