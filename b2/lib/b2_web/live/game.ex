defmodule B2Web.Game do
  use B2Web, :live_view

  def mount(_params, _session, socket) do
    game = Hangman.new_game()
    tally = Hangman.tally(game)

    socket =
      socket
      |> assign(%{
        game: game,
        tally: tally
      })

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.live_component module={__MODULE__.Figure} tally={assigns.tally} id={1} />
      <.live_component module={__MODULE__.Alphabet} tally={assigns.tally} id={2} />
      <.live_component module={__MODULE__.WordSoFar} tally={assigns.tally} id={3} />
    </div>
    """
  end
end
