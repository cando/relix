defmodule Relix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      if Mix.env() == :test,
        do: [],
        else: [
          recipe_store_child_spec()
        ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Relix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp recipe_store_child_spec() do
    impl_module = Application.get_env(:relix, :recipe_store)
    Supervisor.child_spec(Module.concat(impl_module, Supervisor), [])
  end
end
