defmodule Poker do
  
  @doc "Gets a shuffled deck of cards"
  def get_shuffled_deck do
    suits = Stream.cycle([:clubs, :spades, :diamonds, :hearts]) |> Enum.take 52
    cards = Stream.cycle(Cards.get_card_ranks) |> Enum.take 52
    (cards |> Enum.zip suits) |> Enum.shuffle
  end
  
  @doc "Simulates dealing 5 cards to each player"
  def deal(num_players) do
  	get_shuffled_deck 
  	  |> Enum.take(num_players * 5) 
  	  |> Enum.chunk(5)
  end

  @doc "returns the index of the winning hand. E.g. 0 for player 1"
  def find_winning_hand(hands) do
      hands 
      |> Enum.map(&Hand.get_hand_value/1)
      |> Enum.map(&Tuple.to_list/1) 
      |> Enum.with_index 
      |> Enum.sort 
      |> List.last 
      |> elem(1)      
  end
end
