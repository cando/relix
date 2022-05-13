defmodule Relix.RecipeStore.PostgresStore.RecipeItem do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Relix.RecipeStore.PostgresStore

  @primary_key false
  schema "recipe_items" do
    field :name, :string, primary_key: true
    field :value, :string
    belongs_to :recipe, PostgresStore.Recipe, primary_key: true
  end

  def changeset(recipe_item, params) do
    recipe_item
    |> cast(params, [:name, :value])
    |> validate_required([:name, :value])
  end
end
