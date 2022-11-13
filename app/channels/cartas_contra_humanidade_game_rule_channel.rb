class CartasContraHumanidadeGameRuleChannel < ApplicationCable::Channel
  require 'json'

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

  def load_white_cards
    data = JSON.parse(File.read('app/channels/white_cards.json'))
    CartasContraHumanidadeGameRuleChannel.broadcast_to @session, { data:, action: 'load_white_cards' }
  end

  def load_black_cards
    data = JSON.parse(File.read('app/channels/black_cards.json'))

    CartasContraHumanidadeGameRuleChannel.broadcast_to @session, { data:, action: 'load_black_cards' }
  end

  def load_cards_in_hands(data)
    players = data['players']

    info_players = []
    white_cards = JSON.parse(File.read('app/channels/white_cards.json'))

    players.each do |player|
      random_cards = white_cards.sample(10)
      white_cards -= random_cards

      info_player = {
        player:,
        cards_in_hands: random_cards
      }

      info_players << info_player
    end

    info_data = {
      info_players:,
      white_cards:
    }

    CartasContraHumanidadeGameRuleChannel.broadcast_to @session, { data: info_data, action: 'load_cards_in_hands' }
  end

  def play_black_card(data)
    CartasContraHumanidadeGameRuleChannel.broadcast_to @session,
                                                       { data: data['selectedBlackCard'], action: 'play_black_card' }
  end

  def update_cards_in_table(data)
    CartasContraHumanidadeGameRuleChannel.broadcast_to @session,
                                                       { data:, action: 'update_cards_in_table' }
  end
end
