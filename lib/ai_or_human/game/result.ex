defmodule AiOrHuman.Game.Result do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(correct_guesses total_guesses)a

  schema "game_results" do
    field :correct_guesses, :integer
    field :total_guesses, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(result, attrs) do
    result
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_number(:correct_guesses, greater_than_or_equal_to: 0)
    |> validate_number(:total_guesses, greater_than: 0)
    |> validate_correct_not_exceed_total()
  end

  defp validate_correct_not_exceed_total(%Ecto.Changeset{} = changeset) do
    total = get_field(changeset, :total_guesses)
    correct = get_field(changeset, :correct_guesses)

    if is_integer(total) && is_integer(correct) && correct > total do
      add_error(changeset, :correct_guesses, "cannot exceed total guesses")
    else
      changeset
    end
  end
end
