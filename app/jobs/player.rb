# frozen_string_literal: true

# A control for Players
class Player
  def initialize
    @redis = Redis.new(url: 'redis://localhost:6379/1')

    @players = []
    @players = JSON.parse(@redis.get('players')) if @redis.get('players')
  end

  def index
    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel',
                                               { players: @players, action: 'list_players' }
  end

  def create(data)
    @players << data

    @redis.set('players', @players.to_json)

    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel', data
  end

  def insert_in_room(player_id, room_id)

    @players.map do |player|
      player['room_id'] = room_id['id'] if player['id'] == player_id
    end

    puts @players

    @redis.set('players', @players.to_json)

    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel', @players
  end
end
