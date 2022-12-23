defmodule AiNum.Repo.Migrations.AddCounts do
  use Ecto.Migration

  def change do

    alter table(:users) do
      add :text_count, :integer, default: 0
      add :image_count, :integer, default: 0
    end
  end
end
