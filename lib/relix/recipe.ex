defmodule Relix.Recipe do
  defstruct [:name, :type, :state, version: 1, items: %{}]

  @type t :: %__MODULE__{
          name: String.t(),
          type: String.t(),
          state: recipe_state,
          version: integer(),
          items: map()
        }

  @approved :approved
  @draft :draft

  @type recipe_state :: :approved | :draft

  @spec new(String.t(), String.t(), map()) :: Relix.Recipe.t()
  def new(name, type, items \\ %{}) do
    with :ok <- validate_name(name),
         :ok <- validate_type(type) do
      %Relix.Recipe{name: name, type: type, state: @draft, items: items}
    end
  end

  def approve(recipe) do
    %Relix.Recipe{recipe | state: @approved}
  end

  @spec add_or_update_item(Relix.Recipe.t(), String.t(), any()) :: Relix.Recipe.t()
  def add_or_update_item(recipe, item_key, item_value) do
    %Relix.Recipe{recipe | items: Map.put(recipe.items, item_key, item_value), state: @draft, version: bump_version recipe}
  end

  defp validate_name(name), do: if(name != nil && String.length(name) > 0, do: :ok, else: :error)
  defp validate_type(type), do: if(type != nil && String.length(type) > 0, do: :ok, else: :error)

  defp bump_version(%{state: state, version: version}), do: if state == @approved, do: version + 1, else: version

end
