# Very quick, inconclusive load test
#
# Start from command line with:
#   elixir --erl "+P 2000000" -S mix run -e LoadTest.run
#
# Note: the +P 2000000 sets maximum number of processes to 2 million

defmodule LoadTest do
  @total_processes 10_000

  def run do

    # warmup
    Relix.RecipeList.new_recipe("WARM", "WARM")
    Relix.RecipeList.get_recipe_by_id(1)

    # real test
    res =
    for id <- 1..@total_processes do
      Task.async(fn ->
        {time, _} = :timer.tc(fn ->
          Relix.RecipeList.new_recipe("r_#{id}", "_")
        end)
        time
      end
      )
    end
    |> Task.await_many()
    avg = Enum.sum(res) / length(res)
    IO.puts("average new_recipe #{avg} μs")

    res =
    for id <- 1..@total_processes do
      Task.async(fn ->
        {time, _} = :timer.tc(fn ->
          Relix.RecipeList.get_recipe_by_id(id)
        end)
        time
      end
      )
    end
    |> Task.await_many()
    avg = Enum.sum(res) / length(res)
    IO.puts("average get_recipe #{avg} μs")
  end
end

LoadTest.run
