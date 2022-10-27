defmodule PhoenixDemo.ResponseGenerator do
  alias PhoenixDemo.Domain.{Account, AccountDetails, AccountBalances, Transaction}
  alias PhoenixDemo.Domain.Institution
  alias PhoenixDemo.Data
  alias PhoenixDemo.RndUtils

  def generate_accounts(token, endpoint) do
    seed = :erlang.phash2(token)
    :rand.seed(:exs1024, {seed, seed, seed})

    num_acc = Enum.random(1..4)

    for idx <- 0..num_acc, into: [] do
      generate_account(endpoint, token, idx)
    end
  end

  defp generate_account(endpoint, token, idx) do
    seed = :erlang.phash2(token) + idx
    :rand.seed(:exs1024, {seed, seed, seed})

    account_name = Data.account_names() |> Enum.random()
    institution_name = Data.institutions() |> Enum.random()
    institution_id = institution_name |> String.downcase() |> String.replace(" ", "_")
    account_id = "acc_#{RndUtils.random_string()}"
    enrollment_id = "enr_#{RndUtils.random_string()}"

    %Account{
      id: account_id,
      name: account_name,
      last_four: Enum.random(1000..9999),
      institution: %Institution{
        id: institution_id,
        name: institution_name
      },
      enrollment_id: enrollment_id,
      links: %{
        balances: "#{endpoint}/accounts/#{account_id}/balances",
        details: "#{endpoint}/accounts/#{account_id}/details",
        self: "#{endpoint}/accounts/#{account_id}",
        transactions: "#{endpoint}/accounts/#{account_id}/transactions"
      }
    }
  end

  def generate_account_by_id(token, endpoint, account_id) do
    accounts = generate_accounts(token, endpoint)

    case Enum.find(accounts, fn e -> e.id == account_id end) do
      nil -> {:error, "Account '#{account_id}' not found"}
      account -> {:ok, account}
    end
  end

  def generate_account_details(token, endpoint, account_id) do
    account = generate_account_by_id(token, endpoint, account_id)

    case account do
      {:ok, account} ->
        acc_details = %AccountDetails{
          account_id: account.id,
          account_number: Enum.random(100_000_000_000..999_999_999_999),
          links: %{
            account: account.links.self,
            self: account.links.details
          },
          routing_numbers: %{
            ach: Enum.random(100_000_000..999_999_999)
          }
        }

        {:ok, acc_details}

      {:error, msg} ->
        {:error, msg}
    end
  end

  def generate_account_balances(token, endpoint, account_id) do
    account = generate_account_by_id(token, endpoint, account_id)
    available = Enum.random(1_000_0..10_000_00) / 100
    ledger = available

    case account do
      {:ok, account} ->
        acc_balances = %AccountBalances{
          account_id: account.id,
          available: available,
          ledger: ledger,
          links: %{
            account: account.links.details,
            self: account.links.balances
          }
        }

        {:ok, acc_balances}

      {:error, msg} ->
        {:error, msg}
    end
  end

  def generate_transactions(token, endpoint, account_id) do
    acc_balance = generate_account_balances(token, endpoint, account_id)

    num_transactions = 90
    end_date = DateTime.utc_now()

    case acc_balance do
      {:ok, acc_balance} ->
        transactions =
          Enum.map_reduce(1..num_transactions, acc_balance.available, fn idx, acc ->
            generate_transaction(
              account_id,
              DateTime.add(end_date, 24 * idx, :hour),
              token,
              endpoint,
              idx,
              acc
            )
          end)
          |> Kernel.elem(0)

        {:ok, transactions}

      {:error, msg} ->
        {:error, msg}
    end
  end

  defp generate_transaction(account_id, date, token, endpoint, idx, balance) do
    seed = :erlang.phash2(token) + idx
    :rand.seed(:exs1024, {seed, seed, seed})

    transaction_id = "txn_#{RndUtils.random_string()}"
    merchant = Data.merchants() |> Enum.random()
    category = Data.merchant_categories() |> Enum.random()
    amount = Enum.random(10000..1_000_000) / 100
    running_balance = balance + amount

    transaction = %Transaction{
      account_id: account_id,
      amount: Float.round(-amount, 2) |> Float.to_string(),
      date: date,
      description: merchant,
      details: %{
        category: category,
        counterparty: %{
          name: merchant |> String.upcase(),
          type: "organization"
        },
        processing_status: ["complete", "pending"] |> Enum.random()
      },
      id: transaction_id,
      links: %{
        account: "#{endpoint}/accounts/#{account_id}",
        self: "#{endpoint}/accounts/#{account_id}/transactions/#{transaction_id}"
      },
      running_balance: Float.round(running_balance, 2) |> Float.to_string(),
      status: ["posted", "pending"] |> Enum.random()
    }

    {transaction, running_balance}
  end

  def generate_transaction_by_id(token, endpoint, account_id, transaction_id) do
    transactions = generate_transactions(token, endpoint, account_id)

    case transactions do
      {:ok, data} ->
        case Enum.find(data, fn e -> e.id == transaction_id end) do
          nil -> {:error, "Transaction '#{transaction_id}' not found"}
          transaction -> {:ok, transaction}
        end

      {:error, msg} ->
        {:error, msg}
    end
  end
end
