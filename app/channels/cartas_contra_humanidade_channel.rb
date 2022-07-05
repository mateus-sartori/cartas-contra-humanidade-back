# a
class CartasContraHumanidadeChannel < ApplicationCable::Channel
  attr_reader :session

  def subscribed
    @session = params[:session]

    stream_for 'cartas_contra_humanidade_channel'
  end

  def unsubscribed
    Player.new.remove(@session)
    list_players

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
    room = { host: data['host'], id: data['id'] }

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
end
