defmodule PhoenixDemo.Domain.AccountBalances do
  @derive Jason.Encoder

  defstruct account_id: "",
            available: "",
            ledger: "",
            links: %{account: "", self: ""}
end
