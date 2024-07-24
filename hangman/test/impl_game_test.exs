defmodule ImplGameTest do
  use ExUnit.Case
  alias Impl.Game

  test "creates new game" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "creates new game from a given word" do
    game = Game.new_game("hello")

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["h", "e", "l", "l", "o"]
  end

  test "state doesn't change if game is won" do
    for state <- [:won, :lost] do
      game = Game.new_game("hello")
      game = Map.put(game, :game_state, state)
      {new_game, _tally} = Game.make_move(game, "x")
      assert new_game == game
    end
  end

  test "a duplicate letter is reported" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "record used letters" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "y")
    {game, _tally} = Game.make_move(game, "x")
    assert MapSet.equal?(game.used, MapSet.new(["x", "y"]))
  end

  test "we recognize a letter in a word" do
    game = Game.new_game("wombat")
    {_game, tally} = Game.make_move(game, "m")
    assert tally.game_state == :good_guess
    {_game, tally} = Game.make_move(game, "t")
    assert tally.game_state == :good_guess
  end

  test "we recognize a letter not in a word" do
    game = Game.new_game("wombat")
    {_game, tally} = Game.make_move(game, "x")
    assert tally.game_state == :bad_guess
    {_game, tally} = Game.make_move(game, "t")
    assert tally.game_state == :good_guess
    {_game, tally} = Game.make_move(game, "z")
    assert tally.game_state == :bad_guess
  end

  test "can handle a sequence of moves" do
    # hello
    [
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["b", :bad_guess, 5, ["_", "_", "_", "_", "_"], ["a", "b"]],
      ["e", :good_guess, 5, ["_", "e", "_", "_", "_"], ["a", "b", "e"]]
    ]
    |> test_sequence_of_moves()
  end

  test "Can handle a winning game" do
    # hello
    [
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["d", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "d", "e"]],
      ["l", :good_guess, 5, ["_", "e", "l", "l", "_"], ["a", "d", "e", "l"]],
      ["o", :good_guess, 5, ["_", "e", "l", "l", "o"], ["a", "d", "e", "l", "o"]],
      ["m", :bad_guess, 4, ["_", "e", "l", "l", "o"], ["a", "d", "e", "l", "m", "o"]],
      ["h", :won, 4, ["h", "e", "l", "l", "o"], ["a", "d", "e", "h", "l", "m", "o"]],
    ]
    |> test_sequence_of_moves()
  end

  test "Can handle a losing game" do
    # hello
    [
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["b", :bad_guess, 5, ["_", "_", "_", "_", "_"], ["a", "b"]],
      ["c", :bad_guess, 4, ["_", "_", "_", "_", "_"], ["a", "b", "c"]],
      ["d", :bad_guess, 3, ["_", "_", "_", "_", "_"], ["a", "b", "c", "d"]],
      ["e", :good_guess, 3, ["_", "e", "_", "_", "_"], ["a", "b", "c", "d", "e"]],
      ["f", :bad_guess, 2, ["_", "e", "_", "_", "_"], ["a", "b", "c", "d", "e", "f"]],
      ["g", :bad_guess, 1, ["_", "e", "_", "_", "_"], ["a", "b", "c", "d", "e", "f", "g"]],
      ["i", :lost, 0, ["h", "e", "l", "l", "o"], ["a", "b", "c", "d", "e", "f", "g", "i"]],
    ]
    |> test_sequence_of_moves()
  end

  defp test_sequence_of_moves(moves) do
    game = Game.new_game("hello")
    Enum.reduce(moves, game, &check_one_move/2)
  end

  defp check_one_move([guess, state, turns, letters, used], game) do
    {game, tally} = Game.make_move(game, guess)

    assert tally.game_state == state
    assert tally.turns_left == turns
    assert tally.letters == letters
    assert tally.used == used

    game
  end
end
