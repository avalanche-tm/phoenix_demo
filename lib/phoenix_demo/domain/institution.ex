defmodule PhoenixDemo.Domain.Institution do
  alias __MODULE__
  @derive Jason.Encoder

  defstruct id: "", name: ""

  def new() do
    %Institution{id: "", name: ""}
  end
end
