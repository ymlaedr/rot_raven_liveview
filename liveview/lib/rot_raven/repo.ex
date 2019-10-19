defmodule RotRaven.Repo do
  use Ecto.Repo,
    otp_app: :rot_raven,
    adapter: Ecto.Adapters.Postgres
end
