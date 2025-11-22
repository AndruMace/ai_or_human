defmodule AiOrHuman.Game.ImagePair do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(ai_url human_url)a

  schema "image_pairs" do
    field :ai_url, :string
    field :human_url, :string
    field :correct_guess_count, :integer, default: 0
    field :incorrect_guess_count, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(image_pair, attrs) do
    image_pair
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_distinct_images()
  end

  defp validate_distinct_images(changeset) do
    ai_url = get_field(changeset, :ai_url)
    human_url = get_field(changeset, :human_url)

    if ai_url && human_url && ai_url == human_url do
      add_error(changeset, :human_url, "must differ from ai image")
    else
      changeset
    end
  end
end
