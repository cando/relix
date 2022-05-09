defmodule Relix.Recipe do
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

  @spec new(any(), String.t(), String.t(), map()) :: {:ok, %Relix.Recipe{}} | {:error, any()}
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

  @spec add_or_update_item(%Relix.Recipe{}, String.t(), any()) :: %Relix.Recipe{}
  def add_or_update_item(recipe, item_key, item_value) do
    %Relix.Recipe{
      recipe
      | items: Map.put(recipe.items, item_key, item_value),
        state: @draft,
        version: bump_version(recipe)
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
