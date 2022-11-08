# frozen_string_literal: true

# A control for Players
class Player
  def initialize
    @redis = Rails.cache

    @players = []
    @players = JSON.parse(@redis.read('players')) if @redis.read('players')
  end

  def index
    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel',
                                               { players: @players, action: 'list_players' }
  end

  def create(data)
    @players << data

    @redis.write('players', @players.to_json)

    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel', data
  end

  def remove(session)
    @players = @players.reject { |player| player['id'] == session }

    @redis.write('players', @players.to_json)

    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel', @players
  end
end
