require 'json'
class CartasContraHumanidadeRulesController < ApplicationController
  before_action :set_session_info, only: [:players]
  before_action :set_redis, only: %i[players wtf_meo]

  def wtf_meo
    players = @redis.get('players')

    players = [] unless players

    render json: players
  end

  def players
    @redis.set('players', @players.to_json)

    current_players = @redis.get('players')

    render json: current_players
    broadcast(current_players)
  end

  private

  def set_session_info
    @players = params[:currentPlayers]
  end

  def set_redis
    @redis = Redis.new(url: 'redis://localhost:6379/1')
  end

  def broadcast(current_players)
    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel', current_players
  end
end
