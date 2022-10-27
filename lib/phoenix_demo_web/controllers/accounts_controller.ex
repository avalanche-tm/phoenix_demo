defmodule PhoenixDemoWeb.AccountsController do
  use PhoenixDemoWeb, :controller
  alias PhoenixDemo.ResponseGenerator
  alias PhoenixDemoWeb.Endpoint

  plug :auth

  defp auth(conn, _opts) do
    with {user, _pass} <- Plug.BasicAuth.parse_basic_auth(conn) do
      data = user |> String.split("test_") |> List.last()
      assign(conn, :current_user, data)
    else
      _ -> conn |> Plug.BasicAuth.request_basic_auth() |> halt()
    end
  end

  def get_all(conn, %{}) do
    res = ResponseGenerator.generate_accounts(conn.assigns.current_user, Endpoint.url())
    json(conn, res)
  end

  def get_by_id(conn, %{"account_id" => account_id}) do
    res =
      ResponseGenerator.generate_account_by_id(
        conn.assigns.current_user,
        Endpoint.url(),
        account_id
      )

    case res do
      {:ok, data} -> json(conn, data)
      {:error, msg} -> send_resp(conn, :bad_request, msg)
    end
  end

  def get_details(conn, %{"account_id" => account_id}) do
    res =
      ResponseGenerator.generate_account_details(
        conn.assigns.current_user,
        Endpoint.url(),
        account_id
      )

    case res do
      {:ok, data} -> json(conn, data)
      {:error, msg} -> send_resp(conn, :bad_request, msg)
    end
  end

  def get_balances(conn, %{"account_id" => account_id}) do
    res =
      ResponseGenerator.generate_account_balances(
        conn.assigns.current_user,
        Endpoint.url(),
        account_id
      )

    case res do
      {:ok, data} -> json(conn, data)
      {:error, msg} -> send_resp(conn, :bad_request, msg)
    end
  end

  def get_transactions(conn, %{"account_id" => account_id}) do
    res =
      ResponseGenerator.generate_transactions(
        conn.assigns.current_user,
        Endpoint.url(),
        account_id
      )

    case res do
      {:ok, data} -> json(conn, data)
      {:error, msg} -> send_resp(conn, :bad_request, msg)
    end
  end

  def get_transaction_by_id(conn, %{
        "account_id" => account_id,
        "transaction_id" => transaction_id
      }) do
    res =
      ResponseGenerator.generate_transaction_by_id(
        conn.assigns.current_user,
        Endpoint.url(),
        account_id,
        transaction_id
      )

    case res do
      {:ok, data} -> json(conn, data)
      {:error, msg} -> send_resp(conn, :bad_request, msg)
    end
  end
end
