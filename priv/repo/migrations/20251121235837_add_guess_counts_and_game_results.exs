defmodule AiOrHuman.Repo.Migrations.AddGuessCountsAndGameResults do
  use Ecto.Migration

  def change do
    alter table(:image_pairs) do
      add :correct_guess_count, :integer, default: 0, null: false
      add :incorrect_guess_count, :integer, default: 0, null: false
    end

    create table(:game_results) do
      add :correct_guesses, :integer, null: false
      add :total_guesses, :integer, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:game_results, [:inserted_at])
  end
end
