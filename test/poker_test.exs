defmodule PokerTest do
  use ExUnit.Case

  test "2 is less than 3" do
    assert Poker.compare_cards({2,:spades}, {3,:hearts}) == -1
  end

   test "6 is greater than 2" do
    assert Poker.compare_cards({6,:spades}, {2,:hearts}) == 1
  end

  test "3 equals 3" do
    assert Poker.compare_cards({3,:spades}, {3,:hearts}) == 0
  end

  test "6 less than J" do
    assert Poker.compare_cards({2,:spades}, {"j",:hearts}) == -1
  end

  test "Ace equals Ace" do
    assert Poker.compare_cards({"a",:spades}, {"a",:hearts}) == 0
  end

  test "10 less than J is less than Q is less than K is less than A" do
    assert Poker.compare_cards({10,:spades}, {"j",:hearts}) == -1
    assert Poker.compare_cards({"j",:spades}, {"q",:hearts}) == -1
    assert Poker.compare_cards({"q",:spades}, {"k",:hearts}) == -1
    assert Poker.compare_cards({"k",:spades}, {"a",:hearts}) == -1
  end

  test "shuffled deck has 52 cards" do
    assert Poker.get_shuffled_deck |> Enum.count == 52 
  end

  test "shuffled deck has 13 cards for each suit" do
    by_suits = Poker.get_shuffled_deck |> Enum.group_by(fn(c) -> elem(c,1) end)
    assert by_suits |> Dict.fetch!(:spades) |> Enum.count == 13
    assert by_suits |> Dict.fetch!(:hearts) |> Enum.count == 13
    assert by_suits |> Dict.fetch!(:diamonds) |> Enum.count == 13
    assert by_suits |> Dict.fetch!(:clubs) |> Enum.count == 13
  end

  test "shuffled deck has 4 of each card number" do
    by_cards = Poker.get_shuffled_deck |> Enum.group_by(fn(c) -> elem(c,0) end)
    assert by_cards |> Dict.keys |> Enum.count == 13
    by_cards |> Dict.keys |> Enum.each(fn(x)-> assert by_cards |> Dict.fetch!(x) |> Enum.count == 4 end)
  end
end
