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
      random_cards = white_cards.sample(5)
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
                                                       { data: data['blackCard'], action: 'play_black_card' }
  end

  def update_cards_in_table(data)
    CartasContraHumanidadeGameRuleChannel.broadcast_to @session,
                                                       { data:, action: 'update_cards_in_table' }
  end

  def reveal_card_in_table(data)
    cards_in_table = data['cardsInTable']
    card = data['card']

    cards_in_table.map do |card_in_table|
      card_in_table['revealed'] = true if card_in_table['text'] == card['text']
    end

    CartasContraHumanidadeGameRuleChannel.broadcast_to @session,
                                                       { data: cards_in_table, action: 'reveal_card_in_table' }
  end

  def shuffle_cards_in_table(data)
    cards = data['cardsInTable']
    CartasContraHumanidadeGameRuleChannel.broadcast_to @session,
                                                       { data: cards.shuffle, action: 'shuffle_cards_in_table' }
  end

  def update_room(data)
    players = data['players']
    current_player = data['currentPlayer']
    card = data['card']

    players.each do |player|
      player['pending'] = false if player['id'] == current_player['id']
      player['referralCard'] = card if player['id'] == current_player['id'] && card.present?
    end

    CartasContraHumanidadeGameRuleChannel.broadcast_to @session,
                                                       { data: players, action: 'update_room' }
  end

  def winner_player(data)
    player = {
      id: data['id'],
      name: data['name'],
      card: data['referralCard'],
      reveal: true
    }

    CartasContraHumanidadeGameRuleChannel.broadcast_to @session,
                                                       { data: player, action: 'winner_player' }
  end
end
