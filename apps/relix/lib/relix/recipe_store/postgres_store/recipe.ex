defmodule Relix.RecipeStore.PostgresStore.Recipe do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset
  alias Relix.RecipeStore.PostgresStore

  @type recipe_state :: :approved | :draft

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          type: String.t(),
          state: recipe_state,
          version: integer(),
          items: list()
        }

  schema "recipes" do
    field :name, :string
    field :type, :string
    field :version, :integer
    field :state, Ecto.Enum, values: [:draft, :approved]
    has_many :items, PostgresStore.RecipeItem, on_replace: :delete_if_exists
  end

  def changeset(recipe, params \\ %{}) do
    recipe
    |> cast(params, [:id, :name, :type, :version, :state])
    |> cast_assoc(:items)
    |> validate_required([:id, :name, :type, :version, :state])
  end
end
