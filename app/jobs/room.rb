# frozen_string_literal: true

# A control for Rooms
class Room
  def initialize
    @redis = Rails.cache

    @rooms = []
    @rooms = JSON.parse(@redis.read('rooms')) if @redis.read('rooms')
  end

  def index
    @rooms = @rooms.reject { |room| room['players'].blank? }

    @redis.write('rooms', @rooms.to_json)

    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel',
                                               { rooms: @rooms, action: 'list_rooms' }
  end

  def create(data)
    @rooms << data

    @redis.write('rooms', @rooms.to_json)

    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel', data
  end

  def delete(room_id)
    @rooms = @rooms.reject { |room| room['id'] == room_id }

    @redis.write('rooms', @rooms.to_json)

    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel', @rooms
  end

  def delete_by_player_host_disconnect(player_host)
    @rooms = @rooms.reject { |room| room['host'] == player_host }

    @redis.write('rooms', @rooms.to_json)

    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel', @rooms
  end

  def remove_player(player, room_id)
    @rooms.map { |room| room['players'].delete(player) if room['id'] == room_id && room['players'].include?(player) }

    @redis.write('rooms', @rooms.to_json)

    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel', @rooms
  end

  def remove_player_by_disconnect(player_id)
    @rooms.map { |room| room['players'].delete_if { |i| i['id'] == player_id } }

    @redis.write('rooms', @rooms.to_json)

    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel', @rooms
  end

  def insert_player(player, room_id, players_list)
    @rooms.map do |room|
      room['players'] = [] if room['id'] == room_id && players_list.blank?
      room['players'] << player if room['id'] == room_id && room['players'].exclude?(player)
    end

    @redis.write('rooms', @rooms.to_json)

    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel', @rooms
  end

  def start_game(data)
    @rooms = @rooms.each { |room| room['status'] = 'started' if room['id'] == data['session'] }

    @redis.write('rooms', @rooms.to_json)

    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel', data
  end
end
