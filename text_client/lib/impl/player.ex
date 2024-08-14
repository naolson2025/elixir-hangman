defmodule Impl.Player do
  @typep game :: Hangman.game()
  @typep tally :: Hangman.tally()
  @typep state :: {game, tally}

  @spec start(game) :: :ok
  def start(game) do
    tally = Hangman.tally(game)
    interact({game, tally})
  end

  def interact({_game, _tally = %{game_state: :won}}) do
    IO.puts("Congrats, you won!")
  end

  def interact({_game, tally = %{game_state: :lost}}) do
    IO.puts("You LOST!!!! the word was #{tally.letters |> Enum.join()}")
  end

  @spec interact(state) :: :ok
  def interact({game, tally}) do
    IO.puts(feedback_for(tally))
    IO.puts(current_word(tally))
    guess = get_guess()
    tally = Hangman.make_move(game, guess)
    interact({game, tally})
  end

  def get_guess() do
    IO.gets("Next letter: ")
    |> String.trim()
    |> String.downcase()
  end

  def feedback_for(%{game_state: :initializing} = tally) do
    "Welcome, I'm thinking of a #{tally.letters |> length} letter word."
  end

  def feedback_for(%{game_state: :good_guess}), do: "Good guess!"
  def feedback_for(%{game_state: :bad_guess}), do: "Bad guess!"
  def feedback_for(%{game_state: :already_used}), do: "You already used that one idiot 🤣!"

  def current_word(tally) do
    [
      "Word so far: ",
      tally.letters |> Enum.join(" "),
      "    turns left: ",
      tally.turns_left |> to_string(),
      "    used so far: ",
      tally.used |> Enum.join(",")
    ]
  end
end
