defmodule PayAppWeb.TransactionLive.FormComponent do
  use PayAppWeb, :live_component

  alias PayApp.Transactions

  def api_client, do: Application.get_env(:pay_app, :api_client)

  @impl true
  def update(%{transaction: transaction} = assigns, socket) do
    changeset = Transactions.change_transaction(transaction)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"transaction" => transaction_params}, socket) do
    changeset =
      socket.assigns.transaction
      |> Transactions.change_transaction(transaction_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"transaction" => transaction_params}, socket) do
    save_transaction(socket, socket.assigns.action, transaction_params)
  end

  defp save_transaction(socket, :edit, transaction_params) do
    case Transactions.update_transaction(socket.assigns.transaction, transaction_params) do
      {:ok, _transaction} ->
        {:noreply,
         socket
         |> put_flash(:info, "Transaction updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_transaction(socket, :new, transaction_params) do
    %{"hash" => tx_hash} = transaction_params

    case api_client().get_transaction(tx_hash) do
      {:ok, transaction} ->
        create_transaction(socket, transaction)

      {:error, :invalid_hash} ->
        {:noreply,
         socket
         |> put_flash(:error, "Sorry Invalid hash")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, :transaction_not_found} ->
        {:noreply,
         socket
         |> put_flash(:error, "Sorry transaction not found")
         |> push_redirect(to: socket.assigns.return_to)}
    end
  end

  defp create_transaction(socket, transaction) do
    case Transactions.create_transaction(transaction) do
      {:ok, _transaction} ->
        {:noreply,
         socket
         |> put_flash(:info, "Transaction created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
