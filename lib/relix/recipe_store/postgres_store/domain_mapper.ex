defmodule Relix.RecipeStore.PostgresStore.DomainMapper do
  @moduledoc false

  alias Relix.RecipeStore.PostgresStore

  @spec to_domain_recipe(%PostgresStore.Recipe{}) :: %Relix.Recipe{}
  def to_domain_recipe(%PostgresStore.Recipe{} = recipe) do
    recipe
    |> Map.from_struct()
    |> Map.take([:id, :name, :type, :version, :state, :items])
    |> (&struct!(Relix.Recipe, &1)).()
  end
end
