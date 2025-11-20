defmodule AiOrHuman.Repo do
  use Ecto.Repo,
    otp_app: :ai_or_human,
    adapter: Ecto.Adapters.Postgres
end
