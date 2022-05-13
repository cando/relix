defmodule Relix.RecipeStore.PostgresStore.Repo.Migrations.CreateRecipeItems do
  use Ecto.Migration

  def change do
    create table(:recipe_items, primary_key: false) do
      add :name, :string, primary_key: true
      add :value, :string
      add :recipe_id, references(:recipes), primary_key: true
    end
  end
end
