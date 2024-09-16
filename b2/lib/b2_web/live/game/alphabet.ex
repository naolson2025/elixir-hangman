defmodule B2Web.Game.Alphabet do
  use B2Web, :live_component

  def mount(socket) do
    letters = ?a..?z |> Enum.map(&<<&1::utf8>>)
    {:ok, assign(socket, letters: letters)}
  end

  def render(assigns) do
    ~H"""
    <div class="flex">
      <%= for letter <- assigns.letters do %>
        <div
          phx-value-key={letter}
          phx-click="make_move"
          class={"mx-1 #{class_of(letter, @tally)}"}
        >
          <%= letter %>
        </div>
      <% end %>
    </div>
    """
  end

  defp class_of(letter, tally) do
    cond do
      Enum.member?(tally.letters, letter) -> "text-green-500"
      Enum.member?(tally.used, letter) -> "text-red-500"
      true -> ""
    end
  end
end
