defmodule Relix.RecipeStore.MySqlStore.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :relix,
    adapter: Ecto.Adapters.MyXQL

end
