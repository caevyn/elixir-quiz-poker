 defmodule Hand do
  @doc """
  Scores a hand, returning a tuple of scores. 
  The first element scores the hand, the remaining elements are for breaking ties.
  """
  def get_hand_value(hand) do
    values = hand |> sort_hand_values
    if is_flush(hand), do: values |> score_flush, else: values |> score_hand
  end
  
  @doc "Returns true if the provided hand is a flush"
  def is_flush([{_,a}, {_,a}, {_,a}, {_,a}, {_,a}]), do: true
  def is_flush(_), do: false

  defp score_hand([a,a,a,a,b]),  do: {8, a, b}
  defp score_hand([a,b,b,b,b]),  do: {8, b, a}

  defp score_hand([a,a,a,b,b]),  do: {7, a, b}
  defp score_hand([a,a,b,b,b]),  do: {7, b, a}

  defp score_hand([2,3,4,5,14]), do: {5, 5}
  defp score_hand([a,b,c,d,e]) when e - d == 1 and d - c == 1 and c - b == 1 and b - a == 1, do: {5, e}  
  
  defp score_hand([a,a,a,b,c]),  do: {4, a, c, b}
  defp score_hand([a,b,c,c,c]),  do: {4, c, b, a}
  defp score_hand([a,b,b,b,c]),  do: {4, b, c, a}

  defp score_hand([a,a,b,b,c]),  do: {3, b, a, c}
  defp score_hand([a,b,b,c,c]),  do: {3, c, b, a}
  defp score_hand([a,a,b,c,c]),  do: {3, c, a, b}

  defp score_hand([a,a,b,c,d]),  do: {2, a, d, c, b}
  defp score_hand([a,b,b,c,d]),  do: {2, b, d, c, a}
  defp score_hand([a,b,c,c,d]),  do: {2, c, d, b, a}
  defp score_hand([a,b,c,d,d]),  do: {2, d, c, b, a}
  
  defp score_hand([a,b,c,d,e]),  do: {1, e, d, c, b, a}

  defp score_flush(sorted_values) do
    score = sorted_values |> score_hand
    if score |> elem(0) == 5, do:  {9, score |> elem(1)}, else: {6, sorted_values |> Enum.max}
  end
  
  defp sort_hand_values(hand) do
    hand
      |> Enum.map(&Cards.get_card_value/1)
      |> Enum.sort
  end
end