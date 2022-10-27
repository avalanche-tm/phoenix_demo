defmodule PhoenixDemo.Domain.Transaction do
  @derive Jason.Encoder

  defstruct account_id: "",
            amount: "",
            date: "",
            description: "",
            details: %{
              category: "",
              counterparty: %{
                name: "",
                type: ""
              },
              processing_status: ""
            },
            id: "",
            links: %{
              account: "",
              self: ""
            },
            running_balance: "",
            status: "",
            type: "card_payment"
end
