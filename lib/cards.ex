defmodule Cards do
  def get_card_ranks do
    Enum.concat(2..10, ["j","q","k","a"])
  end

  def get_card_value(card) do
    get_card_ranks |> Enum.find_index(fn(r) -> elem(card, 0) == r end) |> + 2
  end
end