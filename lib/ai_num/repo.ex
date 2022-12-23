defmodule AiNum.Repo do
  use Ecto.Repo,
    otp_app: :ai_num,
    adapter: Ecto.Adapters.Postgres
end
