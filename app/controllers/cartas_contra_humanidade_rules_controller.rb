require 'json'
class CartasContraHumanidadeRulesController < ApplicationController
  before_action :set_session_info, only: [:add_players]
  before_action :set_redis, only: %i[add_players players_list]

  def players_list
    players = JSON.parse(@redis.get('players')) if @redis.get('players')

    players ||= []

    render json: players
    broadcast(players)
  end

  def add_players
    @redis.set('players', @players.to_json)

    current_players = JSON.parse(@redis.get('players'))

    render json: current_players
    broadcast(current_players)
  end

  private

  def set_session_info
    @players = params[:players]
  end

  def set_redis
    @redis = Redis.new(url: 'redis://localhost:6379/1')
  end

  def broadcast(current_players)
    CartasContraHumanidadeChannel.broadcast_to 'cartas_contra_humanidade_channel', current_players
  end
end
