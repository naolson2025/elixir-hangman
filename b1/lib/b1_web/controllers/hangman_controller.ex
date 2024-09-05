defmodule B1Web.HangmanController do
  use B1Web, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home)
  end

  def new(conn, _params) do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    conn
    |> put_session(:game, game)
    |> render("game.html", tally: tally)
  end

  def update(conn, params) do
    guess = params["make_move"]["guess"]
    tally =
      conn
      |> get_session(:game)
      |> Hangman.make_move(guess)
    render(conn, "game.html", tally: tally)
  end
end
