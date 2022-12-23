defmodule AiNum.Repo do
  use Ecto.Repo,
    otp_app: :ai_num,
    adapter: Ecto.Adapters.SQLite3
end
