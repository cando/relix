defmodule RelixWeb.RecipeView do
  use RelixWeb, :view
  alias RelixWeb.RecipeView

  def render("index.json", %{recipes: recipes}) do
    %{data: render_many(recipes, RecipeView, "recipe.json")}
  end

  def render("show.json", %{recipe: recipe}) do
    %{data: render_one(recipe, RecipeView, "recipe.json")}
  end

  def render("recipe.json", %{recipe: recipe}) do
    %{
      id: recipe.id,
      name: recipe.name,
      type: recipe.type,
      state: recipe.state,
      version: recipe.version,
      items: recipe.items
    }
  end
end
