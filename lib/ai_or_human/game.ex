defmodule AiOrHuman.Game do
  import Ecto.Query
  alias AiOrHuman.Repo
  alias AiOrHuman.Game.ImagePair

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

  defp build_pair(%ImagePair{} = pair) do
    if Enum.random([true, false]) do
      %{left_url: pair.ai_url, right_url: pair.human_url, ai_position: :left}
    else
      %{left_url: pair.human_url, right_url: pair.ai_url, ai_position: :right}
    end
  end
end
