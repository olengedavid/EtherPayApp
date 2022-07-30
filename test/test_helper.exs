ExUnit.start()
Mox.defmock(ApiClientBehaviourMock, for: PayApp.ApiClientBehaviour)
Ecto.Adapters.SQL.Sandbox.mode(PayApp.Repo, :manual)
