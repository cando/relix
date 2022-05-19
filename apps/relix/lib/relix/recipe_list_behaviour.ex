defmodule Relix.RecipeListBehaviour do
  @moduledoc false

  @callback new_recipe(String.t(), String.t(), map) ::
              {:error, :validation_error} | {:ok, Relix.Recipe.t()}
  @callback get_recipe_by_id(any()) :: {:ok, Relix.Recipe.t()} | {:error, :not_found}
  @callback get_recipes :: [Relix.Recipe.t()]
  @callback approve_recipe(any()) :: {:ok, Relix.Recipe.t()} | {:error, any()}
  @callback delete_recipe(any) :: :ok | {:error, any()}
  @callback rename_recipe(any(), String.t()) :: {:ok, Relix.Recipe.t()} | {:error, :not_found}
  @callback add_or_update_item(any(), String.t(), String.t()) ::
              {:ok, Relix.Recipe.t()} | {:error, any()}
  @callback delete_item(any(), String.t()) :: {:ok, Relix.Recipe.t()} | {:error, any()}
end
