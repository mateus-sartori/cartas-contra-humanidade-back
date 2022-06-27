class CartasContraHumanidadeRulesController < ApplicationController
  before_action :set_session_info, only: [:players]

  def players
    broadcast(@session, @player)
    @players = Player.all
  end

  private

  def set_session_info
    @session = params[:session]
    @player = params[:player]
  end

  def broadcast(session, player)
    CartasContraHumanidadeChannel.broadcast_to session, player
  end
end
