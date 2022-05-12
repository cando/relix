defmodule RelixWeb.RecipeViewTest do
  use RelixWeb.ConnCase, async: true

  alias Relix.Recipe

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders index.json" do
    assert render(RelixWeb.RecipeView, "index.json", %{
             recipes: [Recipe.new(1, "A", "B", %{"1" => "2"}) |> elem(1)]
           }) ==
             %{
               data: [
                 %{
                   id: 1,
                   name: "A",
                   type: "B",
                   state: :draft,
                   version: 1,
                   items: %{"1" => "2"}
                 }
               ]
             }
  end

  test "renders show.json" do
    assert render(RelixWeb.RecipeView, "show.json", %{
             recipe: Recipe.new(1, "A", "B", %{"1" => "2"}) |> elem(1)
           }) ==
             %{
               data: %{
                 id: 1,
                 name: "A",
                 type: "B",
                 state: :draft,
                 version: 1,
                 items: %{"1" => "2"}
               }
             }
  end

  test "renders recipe.json" do
    assert render(RelixWeb.RecipeView, "recipe.json", %{
             recipe: Recipe.new(1, "A", "B", %{"1" => "2"}) |> elem(1)
           }) ==
             %{
               id: 1,
               name: "A",
               type: "B",
               state: :draft,
               version: 1,
               items: %{"1" => "2"}
             }
  end
end
