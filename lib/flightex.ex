defmodule Flightex do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Create, as: CreateBooking
  alias Flightex.Bookings.Get, as: GetBooking
  alias Flightex.Bookings.Report
  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.Create, as: CreateUser
  alias Flightex.Users.Get, as: GetUser

  def start_agents do
    BookingAgent.start_link(%{})
    UserAgent.start_link(%{})
  end

  defdelegate create_booking(user_id, params), to: CreateBooking, as: :call
  defdelegate create_user(params), to: CreateUser, as: :call
  defdelegate get_booking(booking_id), to: GetBooking, as: :call
  defdelegate get_user(user_id), to: GetUser, as: :call
  defdelegate generate_report(from_date, to_date), to: Report, as: :create
end
