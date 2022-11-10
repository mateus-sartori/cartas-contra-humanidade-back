# a
class CartasContraHumanidadeChannel < ApplicationCable::Channel
  attr_reader :session

  def subscribed
    @session = params[:session]

    stream_for 'cartas_contra_humanidade_channel'
  end

  def unsubscribed
    # Remove jogador da sessão
    Player.new.remove(@session)

    # Chamada para atualizar lista de jogadores
    list_players

    # Deleta a sala se host sair e sala, se existir
    disconnect_by_player_host(@session)

    # Deleta jogador da sala caso disconecte da sala
    Room.new.remove_player_by_disconnect(@session)

    # Chamada para atualizar a lista de salas
    list_rooms

    stop_stream_for 'cartas_contra_humanidade_channel'
  end

  # Players Rules

  def create_player(data)
    Player.new.create(data['player'])
  end

  def list_players
    Player.new.index
  end

  # Rooms Rules

  def create_room(data)
    room = { host: data['host'], host_name: data['hostName'], id: data['id'], status: data['status'] }

    Room.new.create(room)
  end

  def list_rooms
    Room.new.index
  end

  def delete_room(data)
    Room.new.delete(data['room_id'])
  end

  def remove_player_from_room(data)
    Room.new.remove_player(data['player'], data['room_id'])
  end

  def put_player_in_room(data)
    Room.new.insert_player(data['player'], data['room_id'], data['players'])
  end

  def disconnect_by_player_host(data)
    Room.new.delete_by_player_host_disconnect(data)
  end

  def start_game(data)
    Room.new.start_game(data)
  end
end
