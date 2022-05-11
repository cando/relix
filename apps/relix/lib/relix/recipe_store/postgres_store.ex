defmodule Relix.RecipeStore.PostgresStore do
  @behaviour Relix.RecipeStore.Behaviour

  import Ecto.Query
  alias Relix.RecipeStore.PostgresStore

  @impl Relix.RecipeStore.Behaviour
  @spec insert(recipe :: %Relix.Recipe{}) :: {:ok, %Relix.Recipe{}} | {:error, any()}
  def insert(recipe) do
    %PostgresStore.Recipe{}
    |> PostgresStore.Recipe.changeset(domain_recipe_to_postgres(recipe))
    |> PostgresStore.Repo.insert()
    |> case do
      {:ok, %PostgresStore.Recipe{} = recipe} ->
        {:ok, PostgresStore.DomainMapper.to_domain_recipe(recipe)}

      {:error, %Ecto.Changeset{errors: errors}} ->
        {:error, errors}
    end
  end

  @impl Relix.RecipeStore.Behaviour
  def update(recipe) do
    %PostgresStore.Recipe{id: recipe.id}
    |> PostgresStore.Recipe.changeset(domain_recipe_to_postgres(recipe))
    |> PostgresStore.Repo.update()
    |> case do
      {:ok, %PostgresStore.Recipe{} = recipe} ->
        {:ok, PostgresStore.DomainMapper.to_domain_recipe(recipe)}

      {:error, %Ecto.Changeset{errors: errors}} ->
        {:error, errors}
    end
  end

  @impl Relix.RecipeStore.Behaviour
  @spec get_next_identity :: any()
  def get_next_identity() do
    Ecto.Adapters.SQL.query!(PostgresStore.Repo, "SELECT nextval('public.recipes_id_seq')").rows
    |> hd
    |> hd
  end

  @impl Relix.RecipeStore.Behaviour
  def get_recipe_by_id(id) do
    case PostgresStore.Repo.get(PostgresStore.Recipe, id)
         |> PostgresStore.Repo.preload([:items]) do
      %PostgresStore.Recipe{} = recipe ->
        recipe |> PostgresStore.DomainMapper.to_domain_recipe()

      _ ->
        :not_found
    end
  end

  @impl Relix.RecipeStore.Behaviour
  @spec get_recipes() :: [%Relix.Recipe{}]
  def get_recipes() do
    query = from(r in PostgresStore.Recipe, preload: [:items])

    PostgresStore.Repo.all(query) |> Enum.map(&PostgresStore.DomainMapper.to_domain_recipe/1)
  end

  @impl Relix.RecipeStore.Behaviour
  @spec delete_by_id(id :: any()) :: :ok | {:error, any()}
  def delete_by_id(id) do
    recipe = PostgresStore.Repo.get(PostgresStore.Recipe, id)

    case recipe do
      nil ->
        {:error, :not_found}

      _ ->
        case PostgresStore.Repo.delete(recipe) do
          {:ok, _struct} ->
            :ok

          {:error, changeset} ->
            {:error, changeset}
        end
    end
  end

  defp domain_recipe_to_postgres(recipe) do
    recipe
    |> Map.from_struct()
    |> Map.update(:items, [], fn items ->
      Enum.map(items, fn {k, v} -> %{name: k, value: v} end)
    end)
  end
end
