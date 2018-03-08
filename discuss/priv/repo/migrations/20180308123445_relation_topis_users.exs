defmodule Discuss.Repo.Migrations.RelationTopisUsers do
  use Ecto.Migration

  def change do

    alter table(:users) do
      add :name, :string, default: "No Body"
    end

    alter table(:topics) do
      add :user_id, references(:users)
    end

  end

end
