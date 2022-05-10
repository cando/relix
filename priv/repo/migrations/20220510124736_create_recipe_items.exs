defmodule Relix.RecipeStore.PostgresStore.Repo.Migrations.CreateRecipeItems do
  use Ecto.Migration

  def change do
    create table(:recipe_items) do
      add :name, :string
      add :value, :string
      add :recipe_id, references(:recipes)
    end
  end
end
