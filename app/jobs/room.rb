# frozen_string_literal: true

# A control for Rooms
class Room
  def initialize
    @redis = Redis.new(url: 'redis://localhost:6379/1')

    @rooms = []
    @rooms = JSON.parse(@redis.get('rooms')) if @redis.get('rooms')
  end

  def index
    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel',
                                               { rooms: @rooms, action: 'list_rooms' }
  end

  def create(data)
    @rooms << data

    @redis.set('rooms', @rooms.to_json)

    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel', data
  end

  def delete(room_id)
    @rooms = @rooms.reject { |room| room['id'] == room_id }

    @redis.set('rooms', @rooms.to_json)

    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel', @rooms
  end

  def remove_player(player, room_id)
    @rooms.map { |room| room['players'].delete(player) if room['id'] == room_id && room['players'].include?(player) }

    @redis.set('rooms', @rooms.to_json)

    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel', @rooms
  end

  def insert_player(player, room_id, players_list)
    @rooms.map do |room|
      room['players'] = [] if room['id'] == room_id && players_list.blank?
      room['players'] << player if room['id'] == room_id && room['players'].exclude?(player)
    end

    @redis.set('rooms', @rooms.to_json)

    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel', @rooms
  end
end
