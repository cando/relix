defmodule RelixWeb.GraphQl.Schema do
  @moduledoc false

  use Absinthe.Schema
  import_types(RelixWeb.GraphQl.Schema.RecipeTypes)

  alias RelixWeb.GraphQl.RecipeResolver

  query do
    @desc "Get all recipes"
    field :all_recipes, list_of(:recipe) do
      resolve(&RecipeResolver.all_recipes/3)
    end

    @desc "Get a recipe"
    field :recipe, :recipe do
      arg(:id, non_null(:id))
      resolve(&RecipeResolver.find_recipe/3)
    end
  end

  mutation do
    @desc "Create a recipe"
    field :create_recipe, type: :recipe do
      arg(:name, non_null(:string))
      arg(:type, non_null(:string))
      arg(:items, list_of(:recipe_item_input))

      resolve(&RecipeResolver.create_recipe/3)
    end

    @desc "Approve a recipe"
    field :approve_recipe, type: :recipe do
      arg(:id, non_null(:id))

      resolve(&RecipeResolver.approve_recipe/3)
    end

    @desc "Rename a recipe"
    field :rename_recipe, type: :recipe do
      arg(:id, non_null(:id))
      arg(:name, non_null(:string))

      resolve(&RecipeResolver.rename_recipe/3)
    end

    @desc "Delete a recipe"
    field :delete_recipe, type: :recipe do
      arg(:id, non_null(:id))

      resolve(&RecipeResolver.delete_recipe/3)
    end

    @desc "Delete a recipe item"
    field :delete_recipe_item, type: :recipe_item do
      arg(:recipe_id, non_null(:id))
      arg(:item_id, non_null(:string))

      resolve(&RecipeResolver.delete_recipe_item/3)
    end

    @desc "Add or update a recipe item"
    field :add_or_update_recipe_item, type: :recipe do
      arg(:recipe_id, non_null(:id))
      arg(:item_id, non_null(:string))
      arg(:item_value, non_null(:string))

      resolve(&RecipeResolver.add_or_update_recipe_item/3)
    end
  end
end
