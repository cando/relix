defmodule RelixWeb.GraphQl.Schema.RecipeTypes do
  @moduledoc false

  use Absinthe.Schema.Notation

  object :recipe_item do
    field :id, non_null(:string)
    field :value, non_null(:string)
  end

  object :recipe do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :type, non_null(:string)
    field :version, non_null(:integer)
    field :items, list_of(:recipe_item)
    field :state, non_null(:string)
  end

  input_object :recipe_item_input do
    field :id, non_null(:string)
    field :value, non_null(:string)
  end
end
