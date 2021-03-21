defmodule Flightex.Bookings.Booking do
  @keys [:data_completa, :cidade_origem, :cidade_destino, :id_usuario]
  @enforce_keys @keys

  defstruct @keys

  def build(data_completa, cidade_origem, cidade_destino, id_usuario)
      when is_bitstring(cidade_origem) and
             is_bitstring(cidade_destino) and is_bitstring(id_usuario) do
    data_completa
    |> validate_date()
    |> handle_response(cidade_origem, cidade_destino, id_usuario)
  end

  def build(_data_completa, _cidade_origem, _cidade_destino, _id_usuario) do
    {:error, "Invalid parameters"}
  end

  def validate_date(data_completa) do
    [head, tail] =
      data_completa
      |> String.split()

    date_with_time = head <> " #{tail}"
    {:ok, NaiveDateTime.from_iso8601!(date_with_time)}
  rescue
    _error in _ -> {:error, "Invalid date, the format must be 'yyyy-mm-dd hh:mm:ss'"}
  end

  defp handle_response({:error, reason}, _cidade_origem, _cidade_destino, _id_usuario),
    do: {:error, reason}

  defp handle_response({:ok, converted_data}, cidade_origem, cidade_destino, id_usuario) do
    {:ok,
     %__MODULE__{
       data_completa: converted_data,
       cidade_origem: cidade_origem,
       cidade_destino: cidade_destino,
       id_usuario: id_usuario
     }}
  end
end
