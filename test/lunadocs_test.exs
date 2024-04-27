defmodule LunadocsTest do
  use ExUnit.Case
  doctest Lunadocs

  test "greets the world" do
    assert Lunadocs.hello() == :world
  end
end
