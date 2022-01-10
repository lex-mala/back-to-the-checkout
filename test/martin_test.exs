defmodule MartinTest do
  use ExUnit.Case
  doctest Martin

  test "greets the world" do
    assert Martin.hello() == :world
  end
end
