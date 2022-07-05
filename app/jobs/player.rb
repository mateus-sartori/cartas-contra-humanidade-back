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

  def remove(session)
    @players = @players.reject { |player| player['id'] == session }

    @redis.set('players', @players.to_json)

    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel', @players
  end
end
