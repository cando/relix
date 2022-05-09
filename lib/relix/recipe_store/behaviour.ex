defmodule Relix.RecipeStore.Behaviour do
  @callback get_recipes() :: [%Relix.Recipe{}]
  @callback save(recipe :: %Relix.Recipe{}) :: :ok
  @callback delete_by_id(id :: any()) :: :ok
  @callback update(recipe :: %Relix.Recipe{}) :: :ok

  # https://matthiasnoback.nl/2018/05/when-and-where-to-determine-the-id-of-an-entity/
  @callback get_next_identity() :: any()
end
