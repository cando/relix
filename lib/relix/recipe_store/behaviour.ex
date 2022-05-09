defmodule Relix.RecipeStore.Behaviour do
  @callback get_recipes() :: [%Relix.Recipe{}]
  @callback save(recipe :: %Relix.Recipe{}) :: :ok
  @callback get_next_identity() :: any()
  @callback delete_by_id(id :: any()) :: :ok
  @callback update(recipe :: %Relix.Recipe{}) :: :ok
end
