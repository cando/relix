defmodule Relix.RecipeStore.PostgresStore.Recipe do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "recipes" do
    field(:name, :string)
    field(:type, :string)
    field(:version, :integer)
    field(:state, Ecto.Enum, values: [:draft, :approved])
  end

  def save_changeset(recipe, params \\ %{}) do
    recipe
    |> cast(params, [:id, :name, :type, :version, :state])
    |> validate_required([:id, :name, :type, :version, :state])
  end
end
