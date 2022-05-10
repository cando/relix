defmodule Relix.RecipeStore.PostgresStore.Recipe do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  alias Relix.RecipeStore.PostgresStore

  schema "recipes" do
    field(:name, :string)
    field(:type, :string)
    field(:version, :integer)
    field(:state, Ecto.Enum, values: [:draft, :approved])
    has_many(:items, PostgresStore.RecipeItem)
  end

  def changeset(recipe, params \\ %{}) do
    recipe
    |> cast(params, [:id, :name, :type, :version, :state])
    |> cast_assoc(:items)
    |> validate_required([:id, :name, :type, :version, :state])
  end
end
