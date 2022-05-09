defmodule Relix.StubRecipeRepo do
  @behaviour Relix.Behaviour.RecipeRepo

  @impl Relix.Behaviour.RecipeRepo
  @spec get_recipes :: [Relix.Recipe.t()]
  def get_recipes() do
    [
      %Relix.Recipe{
        id: 1,
        name: "Recipe1",
        type: "RECIPE",
        state: :draft,
        version: 1,
        items: %{1 => 2}
      }
    ]
  end

  @impl Relix.Behaviour.RecipeRepo
  def save(_recipe) do
    :ok
  end

  @impl Relix.Behaviour.RecipeRepo
  def update(_recipe) do
    :ok
  end

  @impl Relix.Behaviour.RecipeRepo
  def get_next_identity() do
    1
  end

  @impl Relix.Behaviour.RecipeRepo
  def delete_by_id(_id) do
    :ok
  end
end
