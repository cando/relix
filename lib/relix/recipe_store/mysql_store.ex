defmodule Relix.RecipeStore.MySqlStore do
  #@behaviour Relix.RecipeStore.Behaviour

  @doc false
  defdelegate child_spec(opts), to: __MODULE__.Supervisor

end
