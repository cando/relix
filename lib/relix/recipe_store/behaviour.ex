defmodule Relix.RecipeStore.Behaviour do
  @callback get_recipes() :: [%Relix.Recipe{}]
  @callback save(recipe :: %Relix.Recipe{}) :: {:ok, %Relix.Recipe{}} | {:error, any()}
  @callback delete_by_id(id :: any()) :: :ok | {:error, any()}

  # https://matthiasnoback.nl/2018/05/when-and-where-to-determine-the-id-of-an-entity/
  @callback get_next_identity() :: any()
end
