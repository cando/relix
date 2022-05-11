defmodule Relix.RecipeStore.PostgresStore.RecipeItem do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Relix.RecipeStore.PostgresStore

  schema "recipe_items" do
    field(:name, :string)
    field(:value, :string)
    belongs_to(:recipe, PostgresStore.Recipe)
  end

  def changeset(recipe_item, params) do
    recipe_item
    |> cast(params, [:name, :value])
    |> validate_required([:name, :value])
  end
end
