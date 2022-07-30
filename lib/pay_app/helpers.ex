defmodule PayApp.Helpers do
  def underscore_keys(params) do
    params
    |> Enum.map(fn {key, value} -> {Macro.underscore(key), value} end)
    |> Enum.into(%{})
  end

  @spec convert_hex_to_decimal(String.t()) :: integer()
  def convert_hex_to_decimal("0x" <> hex) do
    {int, _} = Integer.parse(hex, 16)
    int
  end
end
