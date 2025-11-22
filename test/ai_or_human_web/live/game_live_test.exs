defmodule AiOrHumanWeb.GameLiveTest do
  use AiOrHumanWeb.ConnCase

  import Phoenix.LiveViewTest

  alias AiOrHuman.Game.ImagePair
  alias AiOrHuman.Repo

  defp image_pair_fixture(attrs \\ %{}) do
    defaults = %{ai_url: "https://example.com/ai.jpg", human_url: "https://example.com/human.jpg"}

    %ImagePair{}
    |> ImagePair.changeset(Map.merge(defaults, attrs))
    |> Repo.insert!()
  end

  test "shows community stats after a guess", %{conn: conn} do
    image_pair_fixture()

    {:ok, view, _html} = live(conn, ~p"/game")

    html =
      view
      |> element("#left-card button", "This is AI")
      |> render_click()

    assert html =~ "Community answers:"
  end

  test "displays community average at the end of the game", %{conn: conn} do
    image_pair_fixture()

    {:ok, view, _html} = live(conn, ~p"/game")

    view
    |> element("#left-card button", "This is AI")
    |> render_click()

    html =
      view
      |> element("button[phx-click=\"next\"]", "Next Challenge")
      |> render_click()

    assert html =~ "Community average accuracy"
  end
end
