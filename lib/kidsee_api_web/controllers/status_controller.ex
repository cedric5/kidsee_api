defmodule KidseeApiWeb.StatusController do
  use KidseeApiWeb, :controller

  alias KidseeApi.Context
  alias KidseeApi.Schemas.Status
  alias JaSerializer.Params
  alias KidseeApi.Repo

  action_fallback KidseeApiWeb.FallbackController

  def index(conn, _params) do
    statuses = Status
               |> Repo.all
    render(conn, "index.json-api", data: statuses)
  end

  def create(conn, %{"data" => data}) do
    attrs = Params.to_attributes(data)
    with {:ok, %Status{} = status} <- Context.create(Status, attrs) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", status_path(conn, :show, status))
      |> render("show.json-api", data: status)
    end
  end

  def show(conn, %{"id" => id}) do
    status = Context.get!(Status, id)
    render(conn, "index.json-api", data: status)
  end

  def update(conn, %{"id" => id, "data" => data}) do
    attrs = Params.to_attributes(data)
    status = Context.get!(Status, id)

    with {:ok, %Status{} = status} <- Context.update(status, attrs) do
      render conn, "show.json-api", data: status
    end
  end

  def delete(conn, %{"id" => id}) do
    status = Context.get!(Status, id)
    with {:ok, %Status{}} <- Context.delete(status) do
      send_resp(conn, :no_content, "")
    end
  end
end
