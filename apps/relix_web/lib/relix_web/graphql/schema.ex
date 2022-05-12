defmodule RelixWeb.GraphQl.Schema do
  @moduledoc false

  use Absinthe.Schema
  import_types RelixWeb.GraphQl.Schema.RecipeTypes

  alias RelixWeb.GraphQl.RecipeResolver

  query do
    @desc "Get all recipes"
    field :all_recipes, list_of(:recipe) do
      resolve &RecipeResolver.all_recipes/3
    end

    @desc "Get a recipe"
    field :recipe, :recipe do
      arg :id, non_null(:id)
      resolve &RecipeResolver.find_recipe/3
    end
  end

  mutation do
    @desc "Create a recipe"
    field :create_recipe, type: :recipe do
      arg :name, non_null(:string)
      arg :type, non_null(:string)

      resolve &RecipeResolver.create_recipe/3
    end
  end
end
