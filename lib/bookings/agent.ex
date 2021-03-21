defmodule Flightex.Bookings.Agent do
  use Agent

  alias Flightex.Bookings.Booking

  def start_link(_initial_state) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%Booking{} = booking) do
    uuid = UUID.uuid4()

    Agent.update(__MODULE__, &update_state(&1, booking, uuid))

    {:ok, uuid}
  end

  def get(uuid), do: Agent.get(__MODULE__, &get_booking(&1, uuid))

  def get_all(from_date, to_date) do
    with {:ok, from_date} <- Booking.validate_date(from_date),
         {:ok, to_date} <- Booking.validate_date(to_date) do
      filtered_bookings =
        Agent.get(__MODULE__, & &1)
        |> Enum.filter(fn {_user_id, %Booking{data_completa: date}} ->
          is_between_dates(date, from_date, to_date)
        end)

      {:ok, filtered_bookings}
    else
      error -> error
    end
  end

  defp is_between_dates(date, from_date, to_date) do
    if NaiveDateTime.diff(date, from_date) >= 0 && NaiveDateTime.diff(date, to_date) <= 0,
      do: true,
      else: false
  end

  defp get_booking(state, uuid) do
    case Map.get(state, uuid) do
      nil -> {:error, "Flight Booking not found"}
      booking -> {:ok, booking}
    end
  end

  defp update_state(state, %Booking{} = booking, uuid), do: Map.put(state, uuid, booking)
end
