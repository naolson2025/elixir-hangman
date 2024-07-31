defmodule Dictionary.Runtime.Server do
  @type t :: pid()
  alias Dictionary.Impl.WordList
  use Agent

  @me __MODULE__

  def start_link(_) do
    Agent.start_link(&WordList.word_list/0, name: @me)
  end

  def random_word() do
    # causes an error for testing
    # if Enum.random(1..100) < 33 do
    #   Agent.get(@me, fn _ -> exit(:boom) end)
    # end
    Agent.get(@me, &WordList.random_word/1)
  end
end
