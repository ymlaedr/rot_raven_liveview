defmodule RotRavenWeb.PageController do
  use RotRavenWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
