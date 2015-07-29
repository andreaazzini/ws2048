defmodule Ws2048.PageController do
  use Ws2048.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
