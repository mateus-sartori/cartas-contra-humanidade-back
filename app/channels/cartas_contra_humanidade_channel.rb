# a
class CartasContraHumanidadeChannel < ApplicationCable::Channel
  def subscribed
    session = params[:session]
    stream_for session
  end

  def unsubscribed
    session = params[:session]
    stop_stream_for session
  end

  def add_player(data)
    Player.create! content: data['content']
  end
end
