defmodule PayAppWeb.PageController do
  use PayAppWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
