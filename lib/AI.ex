defmodule AI do
  def discard(hand) do
    score = Hand.get_hand_value(hand) |> Tuple.to_list
    _discard(hand, score)
  end
  
  #keep the whole hand if we have flush, straight or full house
  defp _discard(hand, [x|tail]) when x==9 or x==7 or x==6 or x==5, do: {hand,[]}
  
  #4 of a kind or 2 pair throw out spare card if it is has a score less than 8, keep it if it is better. 
  defp _discard(hand, [x|tail]) when x==8 or x==3 do
    last = tail |> List.last
    hand |> Enum.partition(fn(x) -> 
      val = Cards.get_card_value(x)
      if val < 8, do: val != last, else: {hand,[]}      
    end)  
  end
  
  #For 3 of a kind, throw away the lowest of the remaining 2 cards.
  defp _discard(hand, [4|tail]), do: hand |> Enum.partition(fn(x) -> Cards.get_card_value(x) != List.last(tail) end)

  #for a pair discard the two lowest spare cards
  defp _discard(hand, [2|tail]) do
    hand |> Enum.partition(fn(x) -> 
      val = Cards.get_card_value(x) 
      val != Enum.at(tail, 2) and val != Enum.at(tail, 3) 
    end)
  end

  #for a high card throw the lowest 4 cards in and hope for the best
  defp _discard(hand, [1|tail]), do: hand |> Enum.partition(fn(x) -> Cards.get_card_value(x) == List.first(tail) end)
end