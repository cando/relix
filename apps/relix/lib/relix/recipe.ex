defmodule Relix.Recipe do
  @moduledoc """
  The main entity handled by relix.
  """
  defstruct [:id, :name, :type, :state, :version, items: %{}]

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          type: String.t(),
          state: recipe_state,
          version: integer(),
          items: map()
        }

  @approved :approved
  @draft :draft

  @type recipe_state :: :approved | :draft

  @spec new(any(), String.t(), String.t(), map()) :: {:ok, Relix.Recipe.t()} | {:error, any()}
  def new(id, name, type, items \\ %{}) do
    with :ok <- validate_name(name),
         :ok <- validate_type(type) do
      {:ok,
       %Relix.Recipe{id: id, name: name, type: type, state: @draft, version: 1, items: items}}
    else
      :validation_error -> {:error, :validation_error}
    end
  end

  def approve(recipe) do
    %Relix.Recipe{recipe | state: @approved}
  end

  @spec add_or_update_item(Relix.Recipe.t(), String.t(), any()) :: Relix.Recipe.t()
  def add_or_update_item(recipe, item_key, item_value) do
    new_items = Map.put(recipe.items, item_key, item_value)

    {new_state, new_version} =
      if Map.equal?(new_items, recipe.items),
        do: {recipe.state, recipe.version},
        else: {@draft, bump_version(recipe)}

    %Relix.Recipe{
      recipe
      | items: new_items,
        state: new_state,
        version: new_version
    }
  end

  @spec delete_item(Relix.Recipe.t(), String.t()) :: Relix.Recipe.t()
  def delete_item(recipe, item_key) do
    new_items = Map.delete(recipe.items, item_key)

    {new_state, new_version} =
      if Map.equal?(new_items, recipe.items),
        do: {recipe.state, recipe.version},
        else: {@draft, bump_version(recipe)}

    %Relix.Recipe{
      recipe
      | items: new_items,
        state: new_state,
        version: new_version
    }
  end

  @spec validate_name(String.t()) :: :ok | :validation_error
  defp validate_name(name),
    do: if(name != nil && String.length(name) > 0, do: :ok, else: :validation_error)

  @spec validate_type(String.t()) :: :ok | :validation_error
  defp validate_type(type),
    do: if(type != nil && String.length(type) > 0, do: :ok, else: :validation_error)

  defp bump_version(%{state: state, version: version}),
    do: if(state == @approved, do: version + 1, else: version)
end
