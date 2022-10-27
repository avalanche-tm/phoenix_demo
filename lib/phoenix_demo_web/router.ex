defmodule PhoenixDemoWeb.Router do
  use PhoenixDemoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PhoenixDemoWeb do
    pipe_through :api
  end

  scope "/accounts", PhoenixDemoWeb do
    get "/", AccountsController, :get_all
    get "/:account_id", AccountsController, :get_by_id
    get "/:account_id/details", AccountsController, :get_details
    get "/:account_id/balances", AccountsController, :get_balances
    get "/:account_id/transactions", AccountsController, :get_transactions
    get "/:account_id/transactions/:transaction_id", AccountsController, :get_transaction_by_id
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: PhoenixDemoWeb.Telemetry
    end
  end
end
