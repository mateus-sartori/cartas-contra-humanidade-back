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
end
