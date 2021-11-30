defmodule Hangman.Impl.GameTest do
  use ExUnit.Case

  alias Hangman.Impl.Game

  test "correct response of new game " do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) >= 0
  end

  test "correct word of new game " do
    game = Game.new_game("fox")

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["f", "o", "x"]
  end

  test "state does not change when game is already won or loss" do
      for game_state <- [:won, :loss] do
      game = Game.new_game()
      game = Map.put(game, :game_state, game_state)
      {new_game, _tally} = Game.make_move(game, "anything")
      assert game == new_game
    end
  end

  test "when a duplicate guess is made" do
    game = Game.new_game("divij")
    {game, _tally} = Game.make_move(game, "m")
    {game, _tally} = Game.make_move(game, "m")
    assert game.game_state == :already_used
  end

  test "to check our used characters set" do
    game = Game.new_game("divij")
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "y")
    {game, _tally} = Game.make_move(game, "x")
    assert MapSet.equal?(game.used, MapSet.new(["x", "y"]))
  end

  test "good guess is recognized" do
    game = Game.new_game("divij")
    {_game, tally} = Game.make_move(game, "d")
    assert tally.game_state == :good_guess
    {_game, tally} = Game.make_move(game, "i")
    assert tally.game_state == :good_guess
  end

  test "bad guess is guessed " do
    game =  Game.new_game("divij")
    {_game, tally} = Game.make_move(game, "d")
    assert tally.game_state == :good_guess
    {_game, tally} = Game.make_move(game, "g")
    assert tally.game_state == :bad_guess
    {_game, tally} = Game.make_move(game, "i")
    assert tally.game_state == :good_guess

  end

  test "sequence guessing" do
    [
      ["e", :good_guess, 7, ["_", "e", "_", "_", "_"], ["e"]],
      ["x", :bad_guess, 6, ["_", "e", "_", "_", "_"], ["e", "x"]],
      ["i", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["e", "i", "x"]],
      ["e", :already_used, 5, ["_", "e", "_", "_", "_"], ["e", "i", "x"]],
      ["o", :good_guess, 5, ["_", "e", "_", "_", "o"], ["e", "i", "o","x"]]
    ]
    |> test_sequence_of_moves()
  end

  def test_sequence_of_moves(script) do
    game = Game.new_game("hello")
    Enum.reduce(script, game, &check_for_move/2)
  end

  def check_for_move([guess, game_state, turns_left, letters, used], game) do
    {game, tally} = Game.make_move(game, guess)
    IO.inspect(game)
    assert tally.turns_left == turns_left
    assert tally.game_state == game_state
    assert tally.used == used
    assert tally.letters == letters

    game
  end
end
