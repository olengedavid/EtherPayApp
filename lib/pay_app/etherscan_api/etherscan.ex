defmodule PayApp.EtherscanApi do
  @behaviour PayApp.ApiClientBehaviour

  @api_base_url "https://api.etherscan.io/api?"
  @api_key Application.fetch_env!(:pay_app, :etherscan_apikey)

  def get_transaction(tx_hash) do
    "#{@api_base_url}module=proxy&action=eth_getTransactionByHash&txhash=#{tx_hash}&apikey=#{@api_key}"
    |> fetch_transaction_json_response()
  end

  def get_latest_block_number do
    "#{@api_base_url}module=proxy&action=eth_blockNumber&apikey=#{@api_key}"
    |> fetch_latest_block_json()
  end

  def fetch_latest_block_json(request_url) do
    case HTTPoison.get(request_url) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        %{"result" => result} = Jason.decode!(body)
        {:ok, result}

      _ ->
        {:error, :unknown_error}
    end
  end

  def fetch_transaction_json_response(request_url) do
    case HTTPoison.get(request_url) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        response = Jason.decode!(body)

        match_transaction_response(response)

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp match_transaction_response(%{"result" => %{"blockHash" => _block_hash} = result}) do
    {:ok, result}
  end

  defp match_transaction_response(%{"error" => %{"code" => -32602}}) do
    {:error, :invalid_hash}
  end

  defp match_transaction_response(%{"result" => nil}), do: {:error, :transaction_not_found}
end
