defmodule Relix.RecipeStore.PostgresStore.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :name, :string
      add :type, :string
      add :version, :integer
      add :state, :string
    end
  end
end
