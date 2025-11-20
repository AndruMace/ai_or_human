defmodule AiOrHumanWeb.GameLive do
  use AiOrHumanWeb, :live_view
  alias AiOrHuman.Game
  import AiOrHumanWeb.ImageCard

  def mount(_params, _session, socket) do
    {:ok, initialize_game(socket)}
  end

  def load_current_pair(socket) do
    current_index = socket.assigns.current_index
    current_pair = Enum.at(socket.assigns.pairs, current_index)

    case current_pair do
      nil ->
        socket
        |> assign(finished?: true)
        |> assign(left_image_url: nil, right_image_url: nil, ai_position: nil)

      _ ->
        socket
        |> assign(finished?: false)
        |> assign(left_image_url: current_pair.left_url)
        |> assign(right_image_url: current_pair.right_url)
        |> assign(ai_position: current_pair.ai_position)
    end
  end

  def handle_event("guess", _params, %{assigns: %{finished?: true}} = socket) do
    {:noreply, socket}
  end

  def handle_event("guess", %{"position" => position}, socket) do
    guessed_position = String.to_atom(position)
    correct_position = socket.assigns.ai_position
    correct? = guessed_position == correct_position

    socket =
      socket
      |> update(:total, &(&1 + 1))
      |> update(:correct, &if(correct?, do: &1 + 1, else: &1))
      |> update(:history, fn history ->
        [
          %{
            pair_index: socket.assigns.current_index,
            ai_position: correct_position,
            guess: guessed_position,
            correct?: correct?
          }
          | history
        ]
      end)
      |> assign(:last_result, correct?)
      |> assign(:show_result, true)

    {:noreply, socket}
  end

  def handle_event("next", _params, %{assigns: %{finished?: true}} = socket) do
    {:noreply, socket}
  end

  def handle_event("next", _params, socket) do
    socket =
      socket
      |> update(:current_index, &(&1 + 1))
      |> assign(:show_result, false)
      |> assign(:last_result, nil)
      |> load_current_pair()

    {:noreply, socket}
  end

  def handle_event("restart", _params, socket) do
    {:noreply, initialize_game(socket)}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-6xl mx-auto p-8">
      <h1 class="text-4xl font-bold text-center mb-8">AI or Human?</h1>

      <div class="text-center mb-6">
        <p class="text-xl">
          Score: {@correct} / {@total}
          <%= if @total > 0 do %>
            ({Float.round(@correct / @total * 100, 1)}%)
          <% end %>
        </p>
      </div>
      <%= if assigns[:error] do %>
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
          {@error}
        </div>
      <% else %>
        <%= if @finished? do %>
          <div class="bg-white border rounded-lg p-8 text-center shadow-md mb-8 text-black">
            <h2 class="text-3xl font-bold mb-4">Game Over!</h2>
            <p class="text-xl mb-2">Final score: {@correct} / {@total}</p>
            <p class="text-lg mb-6">
              Accuracy: {if @total > 0, do: "#{Float.round(@correct / @total * 100, 1)}%", else: "N/A"}
            </p>
            <button
              phx-click="restart"
              class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-3 px-8 rounded-lg"
            >
              Play Again
            </button>
          </div>
        <% else %>
          <div class="grid grid-cols-2 gap-8 mb-8">
            <.image_card
              id="left-card"
              image_url={@left_image_url}
              position={:left}
              ai_position={@ai_position}
              show_result={@show_result}
              real_label="Real"
            />

            <.image_card
              id="right-card"
              image_url={@right_image_url}
              position={:right}
              ai_position={@ai_position}
              show_result={@show_result}
              real_label="Real"
            />
          </div>

          <%= if @show_result do %>
            <div class="text-center">
              <div class={"text-2xl font-bold mb-4 #{if @last_result, do: "text-green-600", else: "text-red-600"}"}>
                {if @last_result, do: "✓ Correct!", else: "✗ Wrong!"}
              </div>
              <button
                phx-click="next"
                class="bg-green-500 hover:bg-green-700 text-white font-bold py-3 px-8 rounded-lg"
              >
                Next Challenge
              </button>
            </div>
          <% end %>
        <% end %>
      <% end %>
      <div class="border-2 rounded-md border-dashed p-6">
        <h1 class="text-xl">TODO:</h1>
        <ul class="list-disc list-inside">
          <li class="line-through">Make images appear in consistent pairs</li>
          <li>Show everage scores at the end</li>
          <li>Show leaderboards at the end</li>
          <li>Add temp usernames for leaderboards</li>
          <li>Use S3 or similar product for image storage</li>
          <li>Collect results, then show averages</li>
        </ul>
      </div>
    </div>
    """
  end

  defp initialize_game(socket) do
    pairs = Game.get_pairs(20)

    socket
    |> assign(
      correct: 0,
      total: 0,
      last_result: nil,
      show_result: false,
      pairs: pairs,
      current_index: 0,
      finished?: false,
      history: []
    )
    |> load_current_pair()
  end
end
