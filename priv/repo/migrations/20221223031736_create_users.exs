defmodule AiNum.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :number, :string
      add :transcript, :string

      timestamps()
    end
  end
end
