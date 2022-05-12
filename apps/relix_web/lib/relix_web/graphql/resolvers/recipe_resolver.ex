defmodule RelixWeb.GraphQl.RecipeResolver do
  @moduledoc false

  alias Relix.RecipeList
  alias Relix.Recipe

  def all_recipes(_root, _args, _info) do
    {:ok, RecipeList.get_recipes() |> Enum.map(&recipe_to_schema_repr/1)}
  end

  def find_recipe(_root, %{id: id}, _info) do
    with {:ok, recipe} <- RecipeList.get_recipe_by_id(id) do
      {:ok, recipe_to_schema_repr(recipe)}
    end
  end

  def create_recipe(_root, %{name: name, type: type}, _info) do
    with {:ok, recipe} <- RecipeList.new_recipe(name, type) do
      {:ok, recipe_to_schema_repr(recipe)}
    end
  end

  defp recipe_to_schema_repr(%Recipe{items: items} = recipe) do
    %Recipe{recipe | items: Enum.into(items, [], fn {k, v} -> %{id: k, value: v} end)}
  end
end
