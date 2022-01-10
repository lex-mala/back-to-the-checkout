defmodule Martin.Item do
  defstruct [:price, :sku]
  @type t :: %__MODULE__{}

  def new(price, sku) do
    %__MODULE__{price: price, sku: sku}
  end
end
