defmodule PayAppWeb.TransactionLiveTest do
  use PayAppWeb.ConnCase

  import Mox
  import Phoenix.LiveViewTest
  import PayApp.TransactionsFixtures

  @tx_hash "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0"

  defp create_transaction(_) do
    transaction = transaction_fixture()
    %{transaction: transaction}
  end

  describe "Index" do
    setup [:create_transaction]

    test "lists all transactions", %{conn: conn, transaction: transaction} do
      {:ok, _index_live, html} = live(conn, Routes.transaction_index_path(conn, :index))

      assert html =~ "Listing Transactions"
      assert html =~ transaction.status
    end

    test "saves new transaction", %{conn: conn} do
      expect(ApiClientBehaviourMock, :get_transaction, fn _args ->
        {:ok,
         %{
           "blockHash" => "0xbaee22af41ce5cb4d28a6a377da26f4fc4f9d893fdfaa6878fb732f42367a947",
           "blockNumber" => "0x4b9b05",
           "from" => "0x0fe426d8f95510f4f0bac19be5e1252c4127ee00",
           "gas" => "0x5208",
           "gasPrice" => "0x4a817c800",
           "hash" => "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0",
           "input" => "0x",
           "nonce" => "0x2",
           "r" => "0xb0a50a9b5e11e36e564d985f3590173a40f231a04c6bfd6132d87244b5b45bcb",
           "s" => "0xa936a6f53d7e001a5f5ba6ca182e7e204a7ed0b8c5a7b874041a179d6e1e994",
           "to" => "0x4848535892c8008b912d99aaf88772745a11c809",
           "transactionIndex" => "0xa0",
           "type" => "0x0",
           "v" => "0x25",
           "value" => "0x526e615a87b5000"
         }}
      end)

      {:ok, index_live, _html} = live(conn, Routes.transaction_index_path(conn, :index))

      assert index_live |> element("a", "New Transaction") |> render_click() =~
               "New Transaction"

      assert_patch(index_live, Routes.transaction_index_path(conn, :new))

      {:ok, _, html} =
        index_live
        |> form("#transaction-form", transaction: %{hash: @tx_hash})
        |> render_submit()
        |> follow_redirect(conn, Routes.transaction_index_path(conn, :index))

      assert html =~ "Transaction created successfully"
      assert html =~ "some status"
      assert html =~ @tx_hash
    end

    test "deletes transaction in listing", %{conn: conn, transaction: transaction} do
      {:ok, index_live, _html} = live(conn, Routes.transaction_index_path(conn, :index))

      assert index_live |> element("#transaction-#{transaction.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#transaction-#{transaction.id}")
    end
  end

  describe "Show" do
    setup [:create_transaction]

    test "displays transaction", %{conn: conn, transaction: transaction} do
      {:ok, _show_live, html} = live(conn, Routes.transaction_show_path(conn, :show, transaction))

      assert html =~ "Show Transaction"
      assert html =~ transaction.status
    end
  end
end
