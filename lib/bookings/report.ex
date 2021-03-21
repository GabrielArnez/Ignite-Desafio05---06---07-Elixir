defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def create(from_date, to_date) do
    case build_booking_list(from_date, to_date) do
      {:ok, booking_list} ->
        File.write("report.csv", booking_list)
        {:ok, "Report generated successfully"}

      {:error, message} ->
        {:error, message}
    end
  end

  defp build_booking_list(from_date, to_date) do
    case BookingAgent.get_all(from_date, to_date) do
      {:ok, bookings} -> {:ok, order_bookings(bookings)}
      {:error, message} -> {:error, message}
      _ -> {:error, "Server error..."}
    end
  end

  defp order_bookings(bookings) do
    bookings
    |> Stream.map(fn {_uuid, booking} -> booking_string(booking) end)
    |> Enum.sort()
  end

  defp booking_string(%Booking{
         cidade_origem: cidade_origem,
         cidade_destino: cidade_destino,
         data_completa: data_completa,
         id_usuario: id_usuario
       }) do
    "#{id_usuario},#{cidade_origem},#{cidade_destino},#{data_completa}\n"
  end
end
