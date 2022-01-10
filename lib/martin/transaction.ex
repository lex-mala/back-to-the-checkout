defmodule Martin.Transaction do
  alias Martin.{Item, Scheme}
  defstruct [:items, :total, :schemes]

  @type t() :: %__MODULE__{items: [Item.t()], schemes: [Scheme.t()]}

  @spec new([Scheme.t()]) :: t()
  def new(schemes) do
    if Enum.all?(schemes, fn %mod{} -> mod == Scheme end) do
      %__MODULE__{items: [], total: 0, schemes: schemes}
    else
      raise "load valid schemes you dingus"
    end
  end

  @spec scan(t(), Item.t()) :: t()
  def scan(%__MODULE__{items: items} = trans, %Item{} = item) do
    %__MODULE__{trans | items: [item | items]}
    |> modify_prices()
    |> recalculate_total()
  end

  defp modify_prices(%__MODULE__{items: items, schemes: schemes} = transaction) do
    items =
      Enum.reduce(schemes, items, fn %Scheme{count: count, sku: sku, price: price}, items ->
        {targeted_items, ignored_items} = split_by_target_sku(items, sku)

        if length(targeted_items) < count do
          targeted_items
        else
          {to_modify, ignored_targets} = split_by_modifiable(targeted_items, count)
          modify_targets(to_modify, price) ++ ignored_targets
        end ++ ignored_items
      end)

    %__MODULE__{transaction | items: items}
  end

  defp modify_targets(items, price) do
    Enum.map(items, &%Item{&1 | price: price})
  end

  defp split_by_modifiable(items, count) do
    items
    |> Enum.sort_by(& &1.price, :asc)
    |> Enum.chunk_every(count)
    |> Enum.split_with(&(length(&1) == count))
    |> Tuple.to_list()
    |> Enum.map(&List.flatten/1)
    |> List.to_tuple()
  end

  defp split_by_target_sku(items, :all) do
    {items, []}
  end

  defp split_by_target_sku(items, sku) do
    Enum.split_with(items, &(&1.sku == sku))
  end

  defp recalculate_total(%__MODULE__{items: items} = transaction) do
    %__MODULE__{transaction | total: Enum.reduce(items, 0, &(&1.price + &2))}
  end
end
