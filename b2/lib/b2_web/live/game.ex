defmodule B2Web.Game do
  use B2Web, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    hello hangman
    """
  end
end
