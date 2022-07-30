# EtherPayApp

### PREREQUISITES
  * Register account on ['Etherscan'](https://docs.etherscan.io/getting-started/creating-an-account) to acquire the api key.
  
 ### START SERVER
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000/transactions`](http://localhost:4000/transactions) from your browser.

### DESIGN DECISIONS

  * A transaction hash is entered on a simple web page, which is wired to  issue a http request to etherscan api for the transaction. Small changes are made on the received request as per the transaction schema structure and saved on the database. This procedure resembles receiving payment.
  
  * To confirm payment, the latest block number is fetch by a genserver after every 10 seconds, if the a transaction status is received and there are at least two blocks, the transactions is updated as complete. 

  * For testing purposes I used  ['mox'](https://github.com/dashbitco/mox), which enabled me to explicitly define set behaviours with return expectations and used mox to mock them.

  * If transactions could be many, possible solution would to start several gen servers in parralel to update all pending transactions within the shortest time possible. Alternatively, Oban offers an easily way to manage jobs promising realibilty, consistency and scalability.
