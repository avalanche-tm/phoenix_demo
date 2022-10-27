defmodule PhoenixDemo.RndUtils do
  def random_string(length \\ 21) do
    available_chars = '0123456789abcdefghijklmnopqrstvwxyuvz'
    for _ <- 1..length, into: "", do: <<Enum.random(available_chars)>>
  end
end
