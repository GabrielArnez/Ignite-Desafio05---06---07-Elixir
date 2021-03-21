defmodule Flightex.Factory do
  use ExMachina

  alias Flightex.Bookings.Booking
  alias Flightex.Users.User

  def user_factory do
    %User{
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      cpf: Faker.Code.isbn10()
    }
  end

  def booking_factory do
    %Booking{
      data_completa: "2021-03-21 15:00:00",
      cidade_origem: Faker.Address.city(),
      cidade_destino: Faker.Address.city(),
      id_usuario: Faker.UUID.v4()
    }
  end
end
