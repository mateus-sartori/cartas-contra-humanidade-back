class CartasContraHumanidadeGameRuleChannel < ApplicationCable::Channel
  def subscribed
    @session = params[:session]
    stream_for @session
  end

  def unsubscribed
    @session = params[:session]
    stop_stream_for @session
  end

  def boss_round(data)
    CartasContraHumanidadeGameRuleChannel.broadcast_to @session,
                                                       { data: data['bossRound'], action: 'set_boss_round' }
  end

  def load_black_cards
    data = [
      {
        id: 1,
        text: 'Durante o sexo, gosto de pensar em _______'
      },
      {
        id: 2,
        text: 'Em seus momentos finais Michael Jackson pensou em _______'
      },
      {
        id: 3,
        text: 'Idosos tem cheiro de que?'
      },
      {
        id: 4,
        text: 'Guerra! Para que serve?'
      },
      {
        id: 5,
        text: 'O que me causa gases incontroláveis?'
      },
      {
        id: 6,
        text: 'Bebo para esquecer____'
      },
      {
        id: 7,
        text: 'Buscando aumentar sua audiência, o museu de História Natural abriu uma exposição interativa sobre ____'
      }
    ]

    CartasContraHumanidadeGameRuleChannel.broadcast_to @session, { data:, action: 'load_black_cards' }
  end

  def play_black_card(data)
    CartasContraHumanidadeGameRuleChannel.broadcast_to @session,
                                                       { data: data['selectedBlackCard'], action: 'play_black_card' }
  end
end
