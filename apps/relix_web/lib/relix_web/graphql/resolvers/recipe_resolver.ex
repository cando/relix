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

  def create_recipe(_root, %{name: name, type: type, items: items}, _info) do
    with {:ok, recipe} <-
           RecipeList.new_recipe(
             name,
             type,
             items |> Map.new(fn %{id: id, value: value} -> {id, value} end)
           ) do
      {:ok, recipe_to_schema_repr(recipe)}
    end
  end

  def approve_recipe(_root, %{id: id}, _info) do
    with {:ok, recipe} <- RecipeList.approve_recipe(id) do
      {:ok, recipe_to_schema_repr(recipe)}
    end
  end

  def rename_recipe(_root, %{id: id, name: name}, _info) do
    with {:ok, recipe} <- RecipeList.rename_recipe(id, name) do
      {:ok, recipe_to_schema_repr(recipe)}
    end
  end

  def delete_recipe(_root, %{id: id}, _info) do
    with :ok <- RecipeList.delete_recipe(id) do
      {:ok, %{id: id}}
    end
  end

  def delete_recipe_item(_root, %{recipe_id: recipe_id, item_id: item_id}, _info) do
    with {:ok, _} <- RecipeList.delete_item(recipe_id, item_id) do
      {:ok, %{id: item_id}}
    end
  end

  def add_or_update_recipe_item(
        _root,
        %{recipe_id: recipe_id, item_id: item_id, item_value: item_value},
        _info
      ) do
    with {:ok, recipe} <- RecipeList.add_or_update_item(recipe_id, item_id, item_value) do
      {:ok, recipe_to_schema_repr(recipe)}
    end
  end

  defp recipe_to_schema_repr(%Recipe{items: items} = recipe) do
    %Recipe{recipe | items: Enum.into(items, [], fn {k, v} -> %{id: k, value: v} end)}
  end
end
