defmodule Relix.RecipeStore.InMemoryStore.DomainMapper do
  @moduledoc false

  @spec to_domain_recipe(Relix.Recipe.t()) :: Relix.Recipe.t()
  def to_domain_recipe(%Relix.Recipe{} = recipe) do
    recipe
  end
end
