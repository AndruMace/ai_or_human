defmodule AiOrHumanWeb.ImageCard do
  use Phoenix.Component

  attr :id, :string, required: true
  attr :image_url, :string, required: true
  attr :position, :atom, required: true
  attr :ai_position, :atom, required: true
  attr :show_result, :boolean, required: true
  attr :real_label, :string, default: "Real"

  def image_card(assigns) do
    ~H"""
    <div id={@id} class="text-center">
      <img
        src={@image_url}
        alt={"Image #{String.capitalize(to_string(@position))}"}
        class="w-full h-96 object-cover rounded-lg shadow-lg mb-4"
      />
      <%= if @show_result do %>
        <div class={"px-4 py-2 rounded font-bold text-black #{if @ai_position == @position, do: "bg-purple-200", else: "bg-green-200"}"}>
          {if @ai_position == @position, do: "AI Generated", else: @real_label}
        </div>
      <% else %>
        <button
          phx-click="guess"
          phx-value-position={@position}
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-3 px-8 rounded-lg w-full"
        >
          This is AI
        </button>
      <% end %>
    </div>
    """
  end
end
