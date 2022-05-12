defmodule RelixWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use RelixWeb, :controller

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(RelixWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :validation_error}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(RelixWeb.ChangesetView)
    |> render("error.json", error: "name and type must be present")
  end

  def call(conn, {:error, error}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(RelixWeb.ChangesetView)
    |> render("error.json", error: error)
  end
end
