defmodule AiOrHuman.Game do
  import Ecto.Query
  alias AiOrHuman.Repo
  alias AiOrHuman.Game.{ImagePair, Result}

  def get_random_pair do
    ImagePair
    |> order_by(fragment("RANDOM()"))
    |> limit(1)
    |> Repo.one()
    |> case do
      nil ->
        {:error, :no_pairs}

      pair ->
        {:ok, build_pair(pair)}
    end
  end

  def get_pairs(limit \\ 20) do
    ImagePair
    |> order_by(fragment("RANDOM()"))
    |> limit(^limit)
    |> Repo.all()
    |> Enum.map(&build_pair/1)
  end

  def create_image_pair(attrs) do
    %ImagePair{}
    |> ImagePair.changeset(attrs)
    |> Repo.insert()
  end

  def record_pair_guess(nil, _correct?), do: %{correct: 0, incorrect: 0}

  def record_pair_guess(pair_id, correct?) do
    increment =
      if correct? do
        [correct_guess_count: 1]
      else
        [incorrect_guess_count: 1]
      end

    ImagePair
    |> where([p], p.id == ^pair_id)
    |> Repo.update_all([inc: increment],
      returning: [:correct_guess_count, :incorrect_guess_count]
    )
    |> case do
      {1, [updated]} ->
        %{correct: updated.correct_guess_count, incorrect: updated.incorrect_guess_count}

      _ ->
        pair_stats(pair_id)
    end
  end

  def pair_stats(pair_id) do
    ImagePair
    |> where([p], p.id == ^pair_id)
    |> select([p], %{correct: p.correct_guess_count, incorrect: p.incorrect_guess_count})
    |> Repo.one()
    |> case do
      nil -> %{correct: 0, incorrect: 0}
      stats -> stats
    end
  end

  def record_session_result(correct, total) when total > 0 do
    %Result{}
    |> Result.changeset(%{correct_guesses: correct, total_guesses: total})
    |> Repo.insert()
  end

  def average_score do
    {correct_sum, total_sum} =
      Result
      |> select([r], {coalesce(sum(r.correct_guesses), 0), coalesce(sum(r.total_guesses), 0)})
      |> Repo.one()
      |> case do
        nil -> {0, 0}
        tuple -> tuple
      end

    if total_sum == 0 do
      %{correct: 0, total: 0, percentage: nil}
    else
      %{correct: correct_sum, total: total_sum, percentage: correct_sum / total_sum}
    end
  end

  defp build_pair(%ImagePair{} = pair) do
    if Enum.random([true, false]) do
      %{
        id: pair.id,
        left_url: pair.ai_url,
        right_url: pair.human_url,
        ai_position: :left
      }
    else
      %{
        id: pair.id,
        left_url: pair.human_url,
        right_url: pair.ai_url,
        ai_position: :right
      }
    end
  end
end
