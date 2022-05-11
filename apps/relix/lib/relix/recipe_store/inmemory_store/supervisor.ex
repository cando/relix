defmodule Relix.RecipeStore.InMemoryStore.Supervisor do
  @moduledoc false
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_opts) do
    children = [
      Relix.RecipeStore.InMemoryStore
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
