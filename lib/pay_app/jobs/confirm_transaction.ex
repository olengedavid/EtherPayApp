defmodule PayApp.ConfirmTransaction do
  use GenServer

  alias PayApp.Transactions
  alias PayApp.Helpers

  def api_client, do: Application.get_env(:pay_app, :api_client)
  @time_interval 1000

  def start_link(_init_state) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(init_state) do
    schedule_work(:confirm_payment)

    {:ok, init_state}
  end

  def handle_info(:confirm_payment, state) do
    {:ok, block_number} = api_client().get_latest_block_number()
    block_number = Helpers.convert_hex_to_decimal(block_number)

    confirm_transactions(block_number)

    schedule_work(:confirm_payment)
    {:noreply, state}
  end

  def schedule_work(message) do
    Process.send_after(self(), message, @time_interval)
  end

  def confirm_transactions(block_number) do
    Transactions.update_pending_transactions(block_number)
  end
end
