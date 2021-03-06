defmodule PokerTest do
  use ExUnit.Case

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
    assert Hand.is_flush([{3, :spades}, {2, :spades}, {4, :spades}, {5, :spades}, {6, :spades}])
  end

  test "is flush is false when suit not all the same" do
    assert Hand.is_flush([{3, :hearts}, {2, :spades}, {4, :spades}, {5, :spades}, {6, :spades}]) == false
  end

  test "high 6 straight score is {5,6}" do
    assert Hand.get_hand_value([{2, :hearts},{3, :hearts},{4, :clubs},{5, :clubs},{6, :clubs}]) == {5,6}
  end

  test "high K straight score is {5,13}" do
    assert Hand.get_hand_value([{"j", :hearts},{"k", :hearts},{10, :clubs},{"q", :clubs},{9, :clubs}]) == {5,13}
  end
  
  test "high A straight score is {5,14}" do
    assert Hand.get_hand_value([{"j", :hearts},{"k", :hearts},{10, :clubs},{"q", :clubs},{"a", :clubs}]) == {5,14}
  end

  test "low A straight score is {5,5}" do
    assert Hand.get_hand_value([{5, :hearts},{4, :hearts},{3, :clubs},{2, :clubs},{"a", :clubs}]) == {5,5}
  end

  test "high K straight flush is {9,13}" do
    assert Hand.get_hand_value([{"j", :clubs},{"k", :clubs},{10, :clubs},{"q", :clubs},{9, :clubs}]) == {9,13}
  end

  test "four of a kind with four 4s returns {8,4,3}" do
    assert Hand.get_hand_value([{4, :hearts},{4, :clubs},{4, :spades},{4, :diamonds},{3, :clubs}]) == {8,4,3}
  end

  test "full house with 3 kings and 2 4s returns {7,13,4}" do
    assert Hand.get_hand_value([{4, :hearts},{"k", :clubs},{"k", :spades},{"k", :diamonds},{4, :clubs}]) == {7,13,4}
  end

  test "three of a kind with 3 kings returns {4,13,5,4}" do
    assert Hand.get_hand_value([{5, :hearts},{"k", :clubs},{"k", :spades},{"k", :diamonds},{4, :clubs}]) == {4,13,5,4}
  end

  test "2 pair of 2s and 4s returns {3,4,2,5}" do
    assert Hand.get_hand_value([{5, :hearts},{2, :clubs},{2, :spades},{4, :diamonds},{4, :clubs}]) == {3,4,2,5}
  end

  test "2 pair of 2s and 3s returns {3,3,2,6}" do
    assert Hand.get_hand_value([{2, :hearts},{2, :hearts},{3,:hearts},{3, :hearts},{6, :clubs}]) == {3,3,2,6}
  end

  test "3 of a kind with 2s returns {4,2,13,9}" do
    assert Hand.get_hand_value([{2, :clubs},{2, :hearts},{2,:diamonds},{9, :clubs},{"k", :clubs}]) == {4,2,13,9}
  end

  test "Ace high royal Flush gets {9,14}" do
    assert Hand.get_hand_value([{10, :clubs},{"j", :clubs},{"q",:clubs},{"k", :clubs},{"a", :clubs}]) == {9,14}
  end

  test "Flush beats straight and high card" do
    hands = [[{2, :clubs},{4, :clubs},{6,:clubs},{9, :clubs},{"k", :clubs}],
             [{2, :hearts},{3, :diamonds},{4,:hearts},{5, :hearts},{6, :hearts}],
             [{2, :clubs},{4, :clubs},{6,:clubs},{9, :clubs},{"k", :diamonds}]]
    assert Poker.find_winning_hand(hands) == 0
  end

  test "straight flush beats flush and high card" do
    hands = [[{2, :clubs},{4, :clubs},{6,:clubs},{9, :clubs},{"k", :clubs}],
             [{2, :hearts},{3, :hearts},{4,:hearts},{5, :hearts},{6, :hearts}],
             [{2, :clubs},{4, :clubs},{6,:clubs},{9, :clubs},{"k", :diamonds}]]
    assert Poker.find_winning_hand(hands) == 1
  end

  test "three of a kind beats 2 pair and high card" do
    hands = [[{2, :clubs},{2, :hearts},{2,:diamonds},{9, :clubs},{"k", :clubs}],
             [{2, :hearts},{2, :hearts},{3,:hearts},{3, :hearts},{6, :clubs}],
             [{2, :clubs},{4, :clubs},{6,:clubs},{9, :clubs},{"k", :diamonds}]]
    assert Poker.find_winning_hand(hands) == 0
  end

  test "Discard 4 cards if high card hand" do
    hand = [{2, :clubs},{8, :hearts},{7,:diamonds},{9, :clubs},{"k", :clubs}]
    assert AI.discard(hand) == {[{"k", :clubs}],[{2, :clubs},{8, :hearts},{7,:diamonds},{9, :clubs}]}
  end

  test "Keep all cards if royal flush" do
    hand = [{10, :clubs},{"j", :clubs},{"q",:clubs},{"k", :clubs},{"a", :clubs}]
    assert AI.discard(hand) == {hand,[]}
  end

  test "Keep all cards if straight" do
    hand = [{2, :hearts},{3, :diamonds},{4,:hearts},{5, :hearts},{6, :hearts}]
    assert AI.discard(hand) == {hand,[]}
  end

  test "Keep all cards if flush" do
    hand = [{2, :hearts},{9, :hearts},{4,:hearts},{5, :hearts},{6, :hearts}]
    assert AI.discard(hand) == {hand,[]}
  end

  test "Keep all cards if full house" do
    hand = [{2, :hearts},{2, :clubs},{2,:diamonds},{5, :hearts},{5, :clubs}]
    assert AI.discard(hand) == {hand,[]}
  end

  test "Four of kind throw away spare card if less than 8" do
    hand = [{2, :hearts},{2, :clubs},{2,:diamonds},{2, :spades},{5, :clubs}]
    assert AI.discard(hand) == {[{2, :hearts},{2, :clubs},{2,:diamonds},{2, :spades}],[{5, :clubs}]}
  end

  test "Four of kind throw keep spare card if greater than 8" do
    hand = [{2, :hearts},{2, :clubs},{2,:diamonds},{2, :spades},{9, :clubs}]
    assert AI.discard(hand) == {[{2, :hearts},{2, :clubs},{2,:diamonds},{2, :spades},{9, :clubs}], []}
  end

  test "3 of a kind throw away lowest remaining card" do
    hand = [{2, :hearts},{2, :clubs},{2,:diamonds},{3, :spades},{9, :clubs}]
    assert AI.discard(hand) == {[{2, :hearts},{2, :clubs},{2,:diamonds},{9, :clubs}],[{3, :spades}]}
  end

  test "2 of a kind throw away 2 lowest remaining card" do
    hand = [{2, :hearts},{2, :clubs},{5,:diamonds},{3, :spades},{9, :clubs}]
    assert AI.discard(hand) == {[{2, :hearts},{2, :clubs},{9, :clubs}],[{5,:diamonds},{3, :spades}]}
  end

  test "High card throw away 4 lowest remaining cards" do
    hand = [{2, :hearts},{6, :clubs},{5,:diamonds},{3, :spades},{9, :clubs}]
    assert AI.discard(hand) == {[{9, :clubs}],[{2, :hearts},{6, :clubs},{5,:diamonds},{3, :spades}]}
  end


end
