defmodule Martin.Scheme do
  defstruct [:count, :id, :price, :sku]
  @type t :: %__MODULE__{}

  @skus ?a..?z
        |> Enum.to_list()
        |> List.to_string()
        |> String.split("")
        |> Enum.reject(&match?("", &1))
        |> Enum.map(&String.to_atom/1)

  @spec new(integer(), integer()) :: t()
  def new(count, price) do
    %__MODULE__{count: count, price: price, sku: :all}
  end

  @spec new(integer(), integer(), atom()) :: t()
  def new(count, price, sku) when is_integer(count) and is_integer(price) and sku in @skus do
    %__MODULE__{count: count, id: nil, price: price, sku: sku}
  end
end
