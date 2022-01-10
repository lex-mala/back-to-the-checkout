defmodule Martin.SchemeTest do
  use ExUnit.Case

  alias Martin.Scheme

  doctest Martin

  test "new/3" do
    count = 3
    sku = :b
    price = 800
    assert %Scheme{count: ^count, price: ^price, sku: ^sku} = Scheme.new(count, price, sku)
  end
end
