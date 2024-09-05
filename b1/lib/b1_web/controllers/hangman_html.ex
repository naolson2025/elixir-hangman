defmodule B1Web.HangmanHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use B1Web, :html

  embed_templates "hangman_html/*"
end
