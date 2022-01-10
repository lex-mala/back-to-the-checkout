defmodule Martin.TransactionTest do
  use ExUnit.Case

  alias Martin.{Item, Scheme, Transaction}

  doctest Martin

  test "new/2" do
    schemes = [Scheme.new(3, 800)]
    assert %Transaction{items: [], schemes: ^schemes} = Transaction.new(schemes)
  end

  test "scan/2" do
    [one, two, three, four, five] = Enum.map(1..5, fn _ -> Item.new(2000, :a) end)
    [six, seven, eight] = Enum.map(1..3, fn _ -> Item.new(100, :b) end)

    assert [Scheme.new(3, 800, :a), Scheme.new(2, 10, :b)]
           |> Transaction.new()
           |> Transaction.scan(one)
           |> Transaction.scan(two)
           |> Transaction.scan(three)
           |> Transaction.scan(four)
           |> Transaction.scan(five)
           |> Transaction.scan(six)
           |> Transaction.scan(seven)
           |> Transaction.scan(eight)
           |> Map.get(:total) == 6520
  end
end
