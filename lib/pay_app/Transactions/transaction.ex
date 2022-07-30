defmodule PayApp.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :status, :string, default: "received"
    field :block_number, :integer
    field :to, :string
    field :from, :string
    field :block_hash, :string
    field :hash, :string
    field :value, :string

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:status, :block_number, :to, :from, :block_hash, :hash, :value])
    |> validate_required([:hash])
  end
end
