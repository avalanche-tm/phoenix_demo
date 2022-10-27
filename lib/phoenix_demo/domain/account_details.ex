defmodule PhoenixDemo.Domain.AccountDetails do
  @derive Jason.Encoder

  defstruct account_id: "",
            account_number: "",
            links: %{account: "", self: ""},
            routing_numbers: %{ach: ""}
end
