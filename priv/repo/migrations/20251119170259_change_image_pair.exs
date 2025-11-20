defmodule AiOrHuman.Repo.Migrations.ChangeImagePair do
  use Ecto.Migration

  def change do
    drop table(:image_pairs)

    create table(:image_pairs) do
      add :ai_image_id, references(:images, on_delete: :delete_all)
      add :real_image_id, references(:images, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:image_pairs, [:ai_image_id])
    create index(:image_pairs, [:real_image_id])
  end
end
