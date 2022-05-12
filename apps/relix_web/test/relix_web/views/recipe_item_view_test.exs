defmodule RelixWeb.RecipeItemViewTest do
  use RelixWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders index.json" do
    assert render(RelixWeb.RecipeItemView, "index.json", %{
             recipe_items: %{"1" => "2", "A" => "B"}
           }) ==
             %{
               data: [
                 %{
                   id: "1",
                   value: "2"
                 },
                 %{
                   id: "A",
                   value: "B"
                 }
               ]
             }
  end

  test "renders show.json" do
    assert render(RelixWeb.RecipeItemView, "show.json", %{
             recipe_item: %{"1" => "2"}
           }) ==
             %{
               data: %{
                 id: "1",
                 value: "2"
               }
             }
  end

  test "renders recipe.json" do
    assert render(RelixWeb.RecipeItemView, "recipe_item.json", %{
             recipe_item: %{"1" => "2"}
           }) ==
             %{
               id: "1",
               value: "2"
             }
  end
end
