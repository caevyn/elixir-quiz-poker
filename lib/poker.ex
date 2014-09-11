defmodule Poker do
  
  @doc "Gets a shuffled deck of cards"
  def get_shuffled_deck do
    suits = Stream.cycle([:clubs, :spades, :diamonds, :hearts]) |> Enum.take 52
    cards = Stream.cycle(get_card_ranks) |> Enum.take 52
    cards |> Enum.zip suits |> Enum.shuffle
  end

  @doc "compares two cards"
  def compare_cards(a, b) do
    x = a |> get_card_value
    y = b |> get_card_value
    cond do 
      x < y -> -1
      x == y -> 0
      x > y -> 1
    end
  end
  
  @doc "Simulates dealing 5 cards to each player, 1 at a time in turn."
  def deal(num_players) do
  	get_shuffled_deck 
  	  |> Enum.take(num_players * 5) 
  	  |> Enum.chunk(5)
  	  |> List.zip  	      
  end

  def find_winning_hand(hands) do
      
  end

  def score_hand(hand) when is_tuple(hand) do
    sorted_values = hand |> sort_hand_values
    if is_flush(hand) do
      score = sorted_values |> score_straight
      if score == 0, do: {6, sorted_values |> Enum.max}, else: {9, score |> elem(1)}
    else
      sorted_values |> score_hand
    end
  end

  def score_hand([a,a,a,a,b]),  do: {8, a, b}
  def score_hand([a,b,b,b,b]),  do: {8, b, a}

  def score_hand([a,a,a,b,b]),  do: {7, a, b}
  def score_hand([a,a,b,b,b]),  do: {7, b, a}

  def score_hand([2,3,4,5,14]), do: {5, 5}
  def score_hand([a,_,_,_,e])  when e - a == 4, do: {5, e}

  def score_hand([a,a,a,b,c]),  do: {4, a, c, b}
  def score_hand([a,b,c,c,c]),  do: {4, c, b, a}
  def score_hand([a,b,b,b,c]),  do: {4, b, c, a}

  def score_hand([a,a,b,b,c]),  do: {3, b, a, c}
  def score_hand([a,b,b,c,c]),  do: {3, c, b, a}
  def score_hand([a,a,b,c,c]),  do: {3, c, a, b}

  def score_hand([a,a,b,c,d]),  do: {2, a, d, c, b}
  def score_hand([a,b,b,c,d]),  do: {2, b, d, c, a}
  def score_hand([a,b,c,c,d]),  do: {2, c, d, b, a}
  def score_hand([a,b,c,d,d]),  do: {2, d, c, b, a}
  
  def score_hand([a,a,b,c,d]),  do: {2, a, d, c, b}
  def score_hand([a,b,b,c,d]),  do: {2, b, d, c, a}
  def score_hand([a,b,c,c,d]),  do: {2, c, d, b, a}
  def score_hand([a,b,c,d,d]),  do: {2, d, c, b, a}

  def score_hand([a,b,c,d,e]),  do: {1, e, d, c, b, a}

  
  @doc "Returns true if the hand is a flush, otherwise false"
  def is_flush(hand) do
    hand 
      |> Tuple.to_list 
      |> Enum.uniq(fn{_,x} -> x end) 
      |> Enum.count == 1
  end 

  @doc "Scores a straight. 0 if no straight, high card's score if a straight"
  def score_straight(sorted_values) do
    case sorted_values do
      [2,3,4,5,14] -> {5, 5}
      [a,_,_,_,e] when e - a == 4 -> {5, e}
      _ -> 0
    end
  end

  defp sort_hand_values(hand) do
    hand
      |> Tuple.to_list
      |> Enum.map(&get_card_value/1)
      |> Enum.sort
  end

  defp get_card_ranks do
    Enum.concat(2..10, ["j","q","k","a"])
  end

  defp get_card_value(card) do
    get_card_ranks |> Enum.find_index(fn(r) -> elem(card, 0) == r end) |> + 2
  end
end
