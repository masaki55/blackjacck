class Card
  attr_reader :number, :suit

  def initialize(number, suit)
    @number = number
    @suit = suit
  end

  def face_number
    return 10 if %w[J Q K].include?(number)
    return 11 if number == 'A'
    number.to_i
  end
end

class Deck
  def initialize
    @cards = []
    %w[2 3 4 5 6 7 8 9 10 J Q K A].each do |number|
      %w[♠ ♡ ♢ ♣].each do |suit|
        @cards << Card.new(number, suit)
      end
    end
    @cards.shuffle!
  end

  def draw
    @cards.pop
  end
end


class Player
  def attr_reader :name, :cards
    def initialize(name)
        @name = name
        @cards = []
    end

    def draw(deck, unmber)
        @cards << deck.draw(unmber)
        @cards.flatten!
    end
end

class Hand
  def initialize
    @cards = []
  end

  def add_card(card)
    @cards << card
  end

  def score
    sum = 0
    aces = 0

    @cards.each do |card|
      sum += card.face_number
      aces += 1 if card.number == 'A'
    end

    aces.times do
      sum -= 10 if sum > 21
    end

    sum
  end
end

class Blackjack
  def initialize
    @deck = Deck.new
    @player_hand = Hand.new("あなた")
    @dealer_hand = Hand.new("ディーラー")
  end

  def play
    puts "ブラックジャックを始めます。"
    2.times do
      @player_hand.add_card(@deck.draw)
      @dealer_hand.add_card(@deck.draw)
    end

    puts "#{@player.name}の引いたカードは#{@player.cards[0]}です。"
    puts "#{@player.neme}の引いたカードは#{@player.cards[1]}です。"
    puts "#{@dealer.name}の1枚目のカードは #{@dealer_hand.add_card(@deck.draw).face_number}です。"
    puts "#{@player.name}の現在の得点は#{@player_hand.score}です"
    player_turn
    dealer_turn unless @player_hand.score > 21
    determine_winner
  end

  def player_turn
    loop do
      puts "カードを引きますか？ (y/n)"
      answer = gets.chomp.downcase

      if answer == 'y'
        @player_hand.add_card(@deck.draw)
        puts "プレイヤーのカード: #{@player_hand.score}"
        break if @player_hand.score > 21
      elsif answer == 'n'
        break
      else
        puts "yかnを入力してください。"  
      end
    end
  end

  def dealer_turn
    while @dealer_hand.score < 17
      @dealer_hand.add_card(@deck.draw)
    end
  end

  def determine_winner
    if @player_hand.score > 21
      puts "#{@player.name}の負けです！"
    elsif @dealer_hand.score > 21
      puts "#{@player.name}の勝ちです！"
    elsif @player_hand.score > @dealer_hand.score
      puts "#{@player.name}の勝ちです！"
    elsif @player_hand.score < @dealer_hand.score
      puts "#{@player.name}の負けです！"
    else
      puts "引き分けです！"
    end
  end
end
