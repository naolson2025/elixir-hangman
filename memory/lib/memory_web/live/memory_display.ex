defmodule MemoryWeb.MemoryDisplay do
  use MemoryWeb, :live_view

  def mount(_params, _session, socket) do
    Process.send_after(self(), :tick, 1000)
    socket = assign(socket, memory: :erlang.memory)
    {:ok, socket}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 1000)
    socket = assign(socket, memory: :erlang.memory)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <table>
      <%= for { name, value} <- @memory do %>
        <tr>
          <th><%= name %></th>
          <td><%= value %></td>
        </tr>
      <% end  %>
    </table>
    """
  end
end
