defmodule UrlLocker.Repo do
  use Ecto.Repo,
    otp_app: :url_locker,
    adapter: Ecto.Adapters.Postgres
end
