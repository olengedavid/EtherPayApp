defmodule PayApp.ApiClientBehaviour do
  @moduledoc false
  @callback get_transaction(String.t()) :: tuple()
  @callback get_latest_block_number() :: tuple()
end
