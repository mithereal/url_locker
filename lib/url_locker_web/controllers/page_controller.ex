defmodule UrlLockerWeb.PageController do
  use UrlLockerWeb, :controller

  def about(conn, _params) do
    render(conn, :about)
  end
end
