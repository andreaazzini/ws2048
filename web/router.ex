defmodule Ws2048.Router do
  use Ws2048.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Ws2048 do
    pipe_through :browser

    get "/", PageController, :index
  end
end
