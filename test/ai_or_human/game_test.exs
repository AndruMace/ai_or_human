defmodule AiOrHuman.GameTest do
  use AiOrHuman.DataCase

  alias AiOrHuman.Game
  alias AiOrHuman.Game.ImagePair

  defp image_pair_fixture(attrs \\ %{}) do
    defaults = %{ai_url: "https://example.com/ai.jpg", human_url: "https://example.com/human.jpg"}

    %ImagePair{}
    |> ImagePair.changeset(Map.merge(defaults, attrs))
    |> Repo.insert!()
  end

  describe "pair stats" do
    test "record_pair_guess/2 increments counters" do
      pair = image_pair_fixture()

      assert %{correct: 0, incorrect: 0} = Game.pair_stats(pair.id)

      assert %{correct: 1, incorrect: 0} = Game.record_pair_guess(pair.id, true)
      assert %{correct: 1, incorrect: 1} = Game.record_pair_guess(pair.id, false)

      assert %{correct: 1, incorrect: 1} = Game.pair_stats(pair.id)
    end
  end

  describe "session averages" do
    test "average_score/0 returns nil percentage when no results" do
      assert %{percentage: nil, correct: 0, total: 0} = Game.average_score()
    end

    test "average_score/0 aggregates across results" do
      assert {:ok, _} = Game.record_session_result(8, 10)
      assert {:ok, _} = Game.record_session_result(1, 5)

      %{percentage: percentage, correct: 9, total: 15} = Game.average_score()
      assert_in_delta percentage, 0.6, 0.0001
    end
  end
end
