defmodule Relix.DomainMapperTest do
  use ExUnit.Case
  doctest Relix

  alias Relix.RecipeStore.PostgresStore

  test "convert from persisted recipe to domain recipe" do
    postgres_recipe = %PostgresStore.Recipe{
      id: 1,
      name: "a",
      type: "b",
      version: 1,
      state: :draft,
      items: [%PostgresStore.RecipeItem{name: "1", value: "2"}]
    }

    assert %Relix.Recipe{} =
             domain_recipe = PostgresStore.DomainMapper.to_domain_recipe(postgres_recipe)

    assert postgres_recipe.id == domain_recipe.id
    assert postgres_recipe.name == domain_recipe.name
    assert postgres_recipe.type == domain_recipe.type
    assert postgres_recipe.version == domain_recipe.version
    assert postgres_recipe.state == domain_recipe.state
    assert postgres_recipe.items |> hd |> Map.from_struct() |> Map.get(:name) == "1"
    assert postgres_recipe.items |> hd |> Map.from_struct() |> Map.get(:value) == "2"
  end
end
