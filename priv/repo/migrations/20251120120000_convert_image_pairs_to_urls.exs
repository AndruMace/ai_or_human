defmodule AiOrHuman.Repo.Migrations.ConvertImagePairsToUrls do
  use Ecto.Migration

  def up do
    drop_if_exists index(:image_pairs, [:ai_image_id])
    drop_if_exists index(:image_pairs, [:real_image_id])

    alter table(:image_pairs) do
      remove :ai_image_id
      remove :real_image_id
      add :ai_url, :string, null: false
      add :human_url, :string, null: false
    end

    create index(:image_pairs, [:ai_url])
    create index(:image_pairs, [:human_url])

    drop table(:images)
  end

  def down do
    create table(:images) do
      add :url, :string, null: false
      add :is_ai, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end

    drop_if_exists index(:image_pairs, [:ai_url])
    drop_if_exists index(:image_pairs, [:human_url])

    alter table(:image_pairs) do
      remove :ai_url
      remove :human_url
      add :ai_image_id, references(:images, on_delete: :delete_all)
      add :real_image_id, references(:images, on_delete: :delete_all)
    end

    create index(:image_pairs, [:ai_image_id])
    create index(:image_pairs, [:real_image_id])
  end
end
