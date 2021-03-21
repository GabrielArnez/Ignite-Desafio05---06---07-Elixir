defmodule Flightex.Users.Get do
  alias Flightex.Users.Agent, as: UserAgent

  def call(user_id), do: UserAgent.get(user_id)
end
