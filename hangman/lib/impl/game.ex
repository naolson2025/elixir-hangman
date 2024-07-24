defmodule Impl.Game do
  alias Hangman
  alias Type

  # this struct has the same name as the module: Game
  @type t :: %Impl.Game{
          turns_left: integer,
          game_state: Type.state(),
          letters: list(String.t()),
          used: MapSet.t(String.t())
        }
  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  ############ new_game logic ################

  @spec new_game :: t
  def new_game do
    # returns the game struct
    new_game(Dictionary.random_word())
  end

  @spec new_game(String.t()) :: t
  def new_game(word) do
    # returns the game struct
    %__MODULE__{
      letters: word |> String.codepoints()
    }
  end

  ############ make_move logic ################

  @spec make_move(t, String.t()) :: {t, Type.tally()}
  def make_move(%{game_state: state} = game, _guess) when state in [:won, :lost] do
    game
    |> return_with_tally()
  end

  def make_move(game, guess) do
    accept_guess(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally()
  end

  ########### accept guess logic ######################

  defp accept_guess(game, _guess, _already_used = true) do
    %{game | game_state: :already_used}
  end

  defp accept_guess(game, guess, _already_used) do
    %{game | used: MapSet.put(game.used, guess)}
    |> score_guess(Enum.member?(game.letters, guess))
  end

  ########### score_guess logic ######################

  @spec score_guess(t, boolean) :: t
  defp score_guess(game, _good_guess = true) do
    new_state = maybe_won(MapSet.subset?(MapSet.new(game.letters), game.used))
    %{game | game_state: new_state}
  end

  @spec score_guess(t, boolean) :: t
  defp score_guess(%{turns_left: 1} = game, _bad_guess) do
    %{game | game_state: :lost, turns_left: 0}
  end

  @spec score_guess(t, boolean) :: t
  defp score_guess(game, _bad_guess) do
    %{game | game_state: :bad_guess, turns_left: game.turns_left - 1}
  end

  ########### Tally logic ######################

  def tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_guessed_letters(game),
      used: game.used |> MapSet.to_list() |> Enum.sort()
    }
  end

  defp reveal_guessed_letters(%{game_state: :lost} = game) do
    game.letters
  end

  defp reveal_guessed_letters(game) do
    game.letters
    |> Enum.map(fn letter -> MapSet.member?(game.used, letter) |> maybe_reveal(letter) end)
  end

  defp maybe_reveal(true, letter), do: letter
  defp maybe_reveal(_, _letter), do: "_"

  defp return_with_tally(game) do
    {game, tally(game)}
  end

  ############# maybe won ##############
  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess
end
