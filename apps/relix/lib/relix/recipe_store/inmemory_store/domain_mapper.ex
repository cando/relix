defmodule Relix.RecipeStore.InMemoryStore.DomainMapper do
  @moduledoc false

  @spec to_domain_recipe(%Relix.Recipe{}) :: %Relix.Recipe{}
  def to_domain_recipe(%Relix.Recipe{} = recipe) do
    recipe
  end
end
