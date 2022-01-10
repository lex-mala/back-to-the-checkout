defmodule Martin.ItemTest do
  use ExUnit.Case

  alias Martin.Item

  doctest Martin

  test "new/2" do
    price = 800
    sku = :b
    assert %Item{price: ^price, sku: ^sku} = Item.new(price, sku)
  end
end
