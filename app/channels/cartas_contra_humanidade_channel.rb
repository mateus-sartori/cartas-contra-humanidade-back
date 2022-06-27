# a
class CartasContraHumanidadeChannel < ApplicationCable::Channel
  def subscribed
    stream_for 'cartas_contra_humanidade_channel'
  end

  def unsubscribed
    stop_stream_for 'cartas_contra_humanidade_channel'
  end
end
