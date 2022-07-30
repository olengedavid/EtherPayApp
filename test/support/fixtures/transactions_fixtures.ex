defmodule PayApp.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PayApp.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        "status" => "some status",
        "hash" => "some tx_hash",
        "blockNumber" => "0xe88b5e",
        "from" => "some address",
        "to" => "to address",
        "value" => "456789ertyu",
        "hash" => "0x7b6d0e8d812873260291c3f8a9fa99a617"
      })
      |> PayApp.Transactions.create_transaction()

    transaction
  end
end
