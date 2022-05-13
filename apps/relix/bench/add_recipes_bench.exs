# Very quick, inconclusive load test
#
# Start from command line with:
#   elixir --erl "+P 2000000" -S mix run -e LoadTest.run
#
# Note: the +P 2000000 sets maximum number of processes to 2 million

defmodule LoadTest do
  @total_processes 1000

  def run do

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
    IO.puts("average put #{avg} μs")
  end
end

LoadTest.run
