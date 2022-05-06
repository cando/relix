defmodule RelixTest do
  use ExUnit.Case
  doctest Relix

  test "greets the world" do
    assert Relix.hello() == :world
  end
end
