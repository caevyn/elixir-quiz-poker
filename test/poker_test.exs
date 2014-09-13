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
 
  test "deal" do
    #assert 5 |> Poker.deal == 6
  end 

  test "is flush is true when suit the same" do
    assert Poker.is_flush([{3, :spades}, {2, :spades}, {4, :spades}, {5, :spades}, {6, :spades}])
  end

  test "is flush is false when suit not all the same" do
    assert Poker.is_flush([{3, :hearts}, {2, :spades}, {4, :spades}, {5, :spades}, {6, :spades}]) == false
  end

  test "high 6 straight score is {5,6}" do
    assert Poker.get_hand_value([{2, :hearts},{3, :hearts},{4, :clubs},{5, :clubs},{6, :clubs}]) == {5,6}
  end

  test "high K straight score is {5,13}" do
    assert Poker.get_hand_value([{"j", :hearts},{"k", :hearts},{10, :clubs},{"q", :clubs},{9, :clubs}]) == {5,13}
  end
  
  test "high A straight score is {5,14}" do
    assert Poker.get_hand_value([{"j", :hearts},{"k", :hearts},{10, :clubs},{"q", :clubs},{"a", :clubs}]) == {5,14}
  end

  test "low A straight score is {5,5}" do
    assert Poker.get_hand_value([{5, :hearts},{4, :hearts},{3, :clubs},{2, :clubs},{"a", :clubs}]) == {5,5}
  end

  test "high K straight flush is {9,13}" do
    assert Poker.get_hand_value([{"j", :clubs},{"k", :clubs},{10, :clubs},{"q", :clubs},{9, :clubs}]) == {9,13}
  end

  test "four of a kind with four 4s returns {8,4,3}" do
    assert Poker.get_hand_value([{4, :hearts},{4, :clubs},{4, :spades},{4, :diamonds},{3, :clubs}]) == {8,4,3}
  end

  test "full house with 3 kings and 2 4s returns {7,13,4}" do
    assert Poker.get_hand_value([{4, :hearts},{"k", :clubs},{"k", :spades},{"k", :diamonds},{4, :clubs}]) == {7,13,4}
  end

  test "three of a kind with 3 kings returns {4,13,5,4}" do
    assert Poker.get_hand_value([{5, :hearts},{"k", :clubs},{"k", :spades},{"k", :diamonds},{4, :clubs}]) == {4,13,5,4}
  end

  test "Flush beats straight and high card" do
    hands = [[{2, :clubs},{4, :clubs},{6,:clubs},{9, :clubs},{"k", :clubs}],
             [{2, :hearts},{3, :diamonds},{4,:hearts},{5, :hearts},{6, :hearts}],
             [{2, :clubs},{4, :clubs},{6,:clubs},{9, :clubs},{"k", :diamonds}]]
    assert Poker.find_winning_hand(hands) == 0
  end
end
