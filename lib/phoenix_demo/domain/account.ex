defmodule PhoenixDemo.Domain.Account do
  alias PhoenixDemo.Domain.Institution

  @derive Jason.Encoder

  defstruct currency: "USD",
            enrollment_id: "",
            id: "",
            institution: Institution.new(),
            last_four: "",
            links: %{
              balances: "",
              details: "",
              self: "",
              transactions: ""
            },
            name: "My Checking",
            subtype: "checking",
            type: "depository"
end
