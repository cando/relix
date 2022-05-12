defmodule RelixWeb.RecipeItemView do
  use RelixWeb, :view
  alias RelixWeb.RecipeItemView

  def render("index.json", %{recipe_items: recipe_items}) do
    %{data: render_many(recipe_items, RecipeItemView, "recipe_item.json")}
  end

  def render("show.json", %{recipe_item: recipe_item}) do
    %{data: render_one(recipe_item, RecipeItemView, "recipe_item.json")}
  end

  def render("recipe_item.json", %{recipe_item: %{} = single_map}) do
    %{
      id: single_map |> Map.keys() |> hd,
      value: single_map |> Map.values() |> hd
    }
  end

  def render("recipe_item.json", %{recipe_item: {k, v}}) do
    %{
      id: k,
      value: v
    }
  end
end
