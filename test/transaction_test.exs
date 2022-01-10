defmodule Martin.TransactionTest do
  use ExUnit.Case

  alias Martin.{Item, Scheme, Transaction}

  doctest Martin

  test "new/2" do
    schemes = [Scheme.new(3, 800)]
    assert %Transaction{items: [], schemes: ^schemes} = Transaction.new(schemes)
  end

  test "scan/2" do
    a = Enum.map(1..5, fn _ -> Item.new(2000, :a) end)
    b = Enum.map(1..3, fn _ -> Item.new(100, :b) end)
    trans = Transaction.new([Scheme.new(3, 800, :a), Scheme.new(2, 10, :b)])
    assert (a ++ b) |> Enum.reduce(trans, &Transaction.scan(&2, &1)) |> Map.get(:total) == 6520
  end
end
