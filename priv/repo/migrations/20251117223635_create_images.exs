defmodule AiOrHuman.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :url, :string
      add :is_ai, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
