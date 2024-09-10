defmodule B1Web.HangmanHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use B1Web, :html

  embed_templates "hangman_html/*"

  @status_field %{
    initializing: {"initializing", "Guess the word, one letter at a time"},
    good_guess: {"good-guess", "Good guess!"},
    bad_guess: {"bad-guess", "Bad guess!"},
    won: {"won", "You won"},
    lost: {"lost", "You lost"},
    already_used: {"already-used", "Already used that letter"}
  }
  def move_status(status) do
    {class, msg} = @status_field[status]
    "<div class='status #{class}'>#{msg}</div>"
  end

  attr :state, :atom, default: :initializing
  # it's not always required, but it's helpful to annotate your function components
  # with these attr/3 calls. More info: https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html#attr/3

  def continue_or_try_again(assigns) do
    # within an elixir file, you begin a block of HEEx code using the ~H sigil.
    # functions that return HEEX must take exactly one param -- an `assigns` map
    # any key from `assigns` can be referenced using @ syntax
    ~H"""
    <.link :if={@state in [:won, :lost]} href={~p"/hangman"}>
      <.button>Try again</.button>
    </.link>
    <.form
      :let={f}
      :if={@state not in [:won, :lost]}
      for={%{}}
      as={:make_move}
      action={~p"/hangman"}
      method="put"
    >
      <.input field={f[:guess]} />
      <.button>Make next guess</.button>
    </.form>
    """
  end

  def figure_for(0) do
    ~s{
      ┌───┐
      │   │
      O   │
     /|\\  │
     / \\  │
          │
    ══════╧══
    }
  end

  def figure_for(1) do
    ~s{
      ┌───┐
      │   │
      O   │
     /|\\  │
     /    │
          │
    ══════╧══
    }
  end

  def figure_for(2) do
    ~s{
    ┌───┐
    │   │
    O   │
   /|\\  │
        │
        │
  ══════╧══
}
  end

  def figure_for(3) do
    ~s{
    ┌───┐
    │   │
    O   │
   /|   │
        │
        │
  ══════╧══
}
  end

  def figure_for(4) do
    ~s{
    ┌───┐
    │   │
    O   │
    |   │
        │
        │
  ══════╧══
}
  end

  def figure_for(5) do
    ~s{
    ┌───┐
    │   │
    O   │
        │
        │
        │
  ══════╧══
}
  end

  def figure_for(6) do
    ~s{
    ┌───┐
    │   │
        │
        │
        │
        │
  ══════╧══
}
  end

  def figure_for(7) do
    ~s{
    ┌───┐
        │
        │
        │
        │
        │
  ══════╧══
}
  end
end
