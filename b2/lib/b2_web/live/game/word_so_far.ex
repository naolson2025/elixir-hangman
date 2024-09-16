defmodule B2Web.Game.WordSoFar do
  use B2Web, :live_component

  @states %{
    already_used: "You alredy picked that letter",
    bad_guess: "That's not in the word",
    good_guess: "Good guess!",
    initializing: "Type or click on your first guess",
    lost: "Sorry, you lost...",
    won: "You won!"
  }

  def mount(socket) do
    {:ok, socket}
  end

  defp state_name(state) do
    @states[state] || "Unknown state"
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col" phx-window-keyup="make_move">
      <%= state_name(@tally.game_state) %>
      <div class="flex">
        <%= for ch <- @tally.letters do %>
          <div class={"pr-3 #{if ch != "_", do: "text-green-500"}"}>
            <%= ch %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
