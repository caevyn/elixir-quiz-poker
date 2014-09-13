defmodule Poker do
  
  @doc "Gets a shuffled deck of cards"
  def get_shuffled_deck do
    suits = Stream.cycle([:clubs, :spades, :diamonds, :hearts]) |> Enum.take 52
    cards = Stream.cycle(get_card_ranks) |> Enum.take 52
    :random.seed(:os.timestamp)
    cards |> Enum.zip suits |> Enum.shuffle #doesn't work real well...
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
  
  @doc "Simulates dealing 5 cards to each player"
  def deal(num_players) do
  	get_shuffled_deck 
  	  |> Enum.take(num_players * 5) 
  	  |> Enum.chunk(5)
  end

  @doc "returns the index of the winning hand. E.g. 0 for player 1"
  def find_winning_hand(hands) do
      hands 
      |> Enum.map(&get_hand_value/1)
      |> Enum.map(&Tuple.to_list/1) 
      |> Enum.with_index 
      |> Enum.sort 
      |> List.last 
      |> elem(1)      
  end
 

  @doc """
  Scores a hand, returning a tuple of scores. 
  The first element scores the hand, the remaining elements are for breaking ties.
  """
  def get_hand_value(hand) do
    values = hand |> sort_hand_values
    if is_flush(hand), do: values |> score_flush, else: values |> score_hand
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
  
  def score_hand([a,b,c,d,e]),  do: {1, e, d, c, b, a}

  @doc "scores a flush. Checks for straight flush or regular flush. TODO: reduce voodoo" 
  def score_flush(sorted_values) do
    score = sorted_values |> score_hand
    if score |> elem(0) == 5, do:  {9, score |> elem(1)}, else: {6, sorted_values |> Enum.max}
  end

  @doc "Returns true if the hand is a flush, otherwise false"
  def is_flush([{_,a}, {_,a}, {_,a}, {_,a}, {_,a}]), do: true
  def is_flush(_), do: false 

  defp sort_hand_values(hand) do
    hand
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
