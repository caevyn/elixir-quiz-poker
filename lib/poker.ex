defmodule Poker do
  def get_shuffled_deck do
    suits = Stream.cycle([:clubs, :spades, :diamonds, :hearts]) |> Enum.take 52
    cards = Stream.cycle(get_card_ranks) |> Enum.take 52
    cards |> Enum.zip suits |> Enum.shuffle
  end

  def compare_cards(a, b) do
    x = a |> get_card_value
    y = b |> get_card_value
    cond do 
      x < y -> -1
      x == y -> 0
      x > y -> 1
    end
  end   

  defp get_card_ranks do
    Enum.concat(2..10, ["j","q","k","a"])
  end

  defp get_card_value(card) do
    get_card_ranks |> Enum.find_index(fn(r) -> elem(card, 0) == r end)
  end
end
