defmodule AiOrHuman.Repo.Migrations.CreateImagePairs do
  use Ecto.Migration

  def change do
    create table(:image_pairs) do
      add :left_image_id, references(:images, on_delete: :delete_all)
      add :right_image_id, references(:images, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:image_pairs, [:left_image_id])
    create index(:image_pairs, [:right_image_id])
  end
end
