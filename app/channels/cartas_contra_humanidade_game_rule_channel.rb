class CartasContraHumanidadeGameRuleChannel < ApplicationCable::Channel
  def subscribed
    stream_for params[:session]
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_stream_for params[:session]
  end
end
