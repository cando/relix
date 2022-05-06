defmodule Relix.RecipeList do
  defstruct recipes: []
  @type t :: %__MODULE__{
    recipes: list(Relix.Recipe.t())
  }

  @spec new :: %Relix.RecipeList{recipes: list(Relix.Recipe.t())}
  def new() do
    %Relix.RecipeList{}
  end

end
