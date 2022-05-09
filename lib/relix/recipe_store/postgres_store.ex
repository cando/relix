defmodule Relix.RecipeStore.PostgresStore do
  @behaviour Relix.RecipeStore.Behaviour

  alias Relix.RecipeStore.PostgresStore.Repo

  @impl Relix.RecipeStore.Behaviour
  def save(recipe) do
    Repo.insert!(recipe)
  end
end
