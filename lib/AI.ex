defmodule AI do
  def discard(hand) do
    score = Hand.get_hand_value(hand) |> Tuple.to_list
    _discard(hand, score)
  end

  defp _discard(hand, [x|tail]) when x==9 or x==7 or x==6 or x==5, do: {hand,[]}

  defp _discard(hand, [x|tail]) when x==8 or x==3 do
    last = tail |> List.last
    hand |> Enum.partition(fn(x) -> Cards.get_card_value(x) != last end)  
  end

  defp _discard(hand, [4|tail]), do: hand |> Enum.partition(fn(x) -> Cards.get_card_value(x) != Enum.at(tail, 2) end)

  defp _discard(hand, [2|tail]) do
    hand |> Enum.partition(fn(x) -> 
      val = Cards.get_card_value(x) 
      val != Enum.at(tail, 2) and val != Enum.at(tail, 3) 
    end)
  end

  defp _discard(hand, [1|tail]), do: hand |> Enum.partition(fn(x) -> Cards.get_card_value(x) == Enum.at(tail, 0) end)
end