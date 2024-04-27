defmodule LunaDocsTest do
  use ExUnit.Case
  doctest LunaDocs

  test "greets the world" do
    assert LunaDocs.hello() == :world
  end
end
