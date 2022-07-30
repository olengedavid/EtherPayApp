defmodule PayApp.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :status, :string
      add :block_number, :integer
      add :from, :string
      add :to, :string
      add :hash, :string
      add :block_hash, :string
      add :value, :string

      timestamps()
    end
  end
end
