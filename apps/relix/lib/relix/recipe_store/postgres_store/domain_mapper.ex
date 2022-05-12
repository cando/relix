defmodule Relix.RecipeStore.PostgresStore.DomainMapper do
  @moduledoc false

  alias Relix.RecipeStore.PostgresStore

  @spec to_domain_recipe(PostgresStore.Recipe.t()) :: Relix.Recipe.t()
  def to_domain_recipe(%PostgresStore.Recipe{} = recipe) do
    recipe
    |> Map.from_struct()
    |> Map.take([:id, :name, :type, :version, :state, :items])
    |> Map.update(:items, [], fn items ->
      Enum.into(items, %{}, fn %PostgresStore.RecipeItem{name: name, value: value} ->
        {name, value}
      end)
    end)
    |> (&struct!(Relix.Recipe, &1)).()
  end
end
