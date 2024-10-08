defmodule Dictionary.Runtime.Application do
  use Application

  def start(_start_type, _start_args) do
    children = [
      {Dictionary.Runtime.Server, []}
    ]

    options = [
      name: Dictionary.Runtime.Supervisor,
      strategy: :one_for_one,
    ]

    Supervisor.start_link(children, options)
  end
end
