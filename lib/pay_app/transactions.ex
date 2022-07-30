defmodule PayApp.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias PayApp.Repo

  alias PayApp.Transactions.Transaction
  alias PayApp.Helpers

  @minimum_block_number 2

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_transaction(map()) :: {:ok, %Transaction{}} | {:error, Ecto.Changeset.t()}
  def create_transaction(attrs \\ %{}) do
    attrs = transform_transaction_params(attrs)

    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  def transform_transaction_params(attrs) do
    attrs
    |> Helpers.underscore_keys()
    |> change_block_number_to_decimal()
  end

  def change_block_number_to_decimal(%{"block_number" => block_number} = attrs) do
    Map.put(attrs, "block_number", Helpers.convert_hex_to_decimal(block_number))
  end

  def change_block_number_to_decimal(attrs) do
    attrs
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end

  def update_pending_transactions(block_number) do
    Transaction
    |> where(
      [t],
      t.status == "received" and ^block_number - t.block_number >= ^@minimum_block_number
    )
    |> update([t], set: [status: "complete"])
    |> Repo.update_all([])
  end
end
