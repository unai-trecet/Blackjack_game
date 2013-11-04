require 'pry'

def gen_deck
  deck = Array.new(52)
  count = 1
  change_suit = 0
  suit = ["spades", "clubs", "diamonds", "hearts"]

  deck.each_index do |card|

    if count > 13
      count = 1
      change_suit = change_suit + 1
    end

    deck[card] = case count
                 when 1 then ["Ace", suit[change_suit]]
                 when 2..10 then [(count).to_s, suit[change_suit]]
                 when 11 then ["Jack", suit[change_suit]]   
                 when 12 then ["Queen", suit[change_suit]]  
                 when 13 then ["King", suit[change_suit]]  
                 end

    count = count + 1
  end
  deck
end

def deal_card deck
  card = 0
  while card == 0
    ran = rand(deck.length)
    card = deck[ran]
  end
  deck[ran] = 0
  card
end

def hand_sum  hand
  sum = 0
  aces = 0
	
  hand.each do |c|
    case c[0]
    when "Ace" then aces = aces + 1
    when "Jack" then sum = sum + 10   
    when "Queen" then sum = sum + 10  
    when "King" then sum = sum + 10  
    else sum = sum + c[0].to_i
    end
  end  
  sum = sum_aces sum, aces  
end

def sum_aces sum, aces
  while true
    if aces > 0 
      if sum <=10
        sum = sum + 11
        aces = aces -1
      else
        sum = sum + 1
		aces = aces -1
      end 
    else 
      break
    end
  end    
  sum
end

def show_hand hand, player
  puts  "Cards are:"
  hand.each {|c| puts c[0] + " of " + c[1]}
  puts "And their sum is: #{hand_sum hand}, "+player+"."
  puts
end

def blackjack name

  deck = gen_deck

  player_hand = []
  dealer_hand = []
  
  player_hand.push(deal_card deck)
  player_hand.push(deal_card deck)

  dealer_hand.push(deal_card deck)
  dealer_hand.push(deal_card deck)

  puts "Dealer\'s starting hand:"
  puts"#{show_hand dealer_hand, "dealer"}" 
  puts
  puts "This is your starting hand, #{name}:"
  puts "#{show_hand player_hand, name}"


  switch = false

  while true
    sum_player = hand_sum player_hand
    
    if  sum_player == 21
      puts "You win #{name}! Congratulations"
      break
    elsif sum_player > 21
      puts "You lose #{name}... Sorry..."
      break	
    end

    puts "Do you want to hit or stay?"
    choice = gets.chomp
    if choice == "hit"
      player_hand.push(deal_card deck)
      show_hand player_hand, name
    elsif choice == "stay"
        puts "Ok, now it\'s dealers turn"
  	  puts
        switch = true   
        break
    else 
      puts "Please write hit or stay, "+name
    end
  end


  if switch
    show_hand dealer_hand, "dealer"
    while true
      sum_dealer = hand_sum dealer_hand
  	  if  sum_dealer == 21
        puts "Dealer wins... You lose #{name}... Sorry..."
        break
      elsif sum_dealer > 21
        puts "Dealer lose #{name}... You win!!"
        break
  	  end
  	
  	  if sum_dealer < 18 || sum_dealer <= sum_player
        dealer_hand.push(deal_card deck)
        show_hand dealer_hand, "dealer"
  	  elsif sum_dealer > sum_player
        puts "Your cars\'s sum is #{sum_player}, and Dealer\'s cards sum is #{sum_dealer}. Dealer wins... You lose #{name}... Sorry..."
        break
      elsif sum_dealer < sum_player
        puts "Your cars\'s sum is #{sum_player}, and Dealer\'s cards sum is #{sum_dealer}. You win #{name}! Congratulations"
        break
      elsif sum_dealer == sum_player
        puts "Your cars\'s sum is #{sum_player}, and Dealer\'s cards sum is #{sum_dealer}. Draw!!"
        break
      end  
    end
  end
end

puts "Hello, do you want to play blackjack? Great!"
puts "What\'s your name please?"
name = gets.chomp
puts
puts "Nice to meet you #{name}, let's start!"
puts

blackjack name

while true
  puts "Do you want to play again? Write yes or no please."
  response = gets.chomp
  if response == "yes"
	puts "Good! Changing the deck!"
    blackjack name
  elsif response == "no"
    puts "Bye!"
    break
  else
    puts "Please, write yes or no."
  end
end 