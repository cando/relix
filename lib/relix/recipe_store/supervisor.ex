defmodule Relix.RecipeStore.Supervisor do
  @moduledoc false
  use Supervisor

  alias Relix.RecipeStore.MySqlStore

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {MySqlStore, name: MySqlStore}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
