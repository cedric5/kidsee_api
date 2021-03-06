defmodule KidseeApi.Schemas.ContentType do
  use KidseeApi.Schema
  alias KidseeApi.Schemas.ContentType

  schema "content_type" do
    field :name, :string
    field :description, :string

    timestamps()
  end

  def preload(query), do: query

  @doc false
  def changeset(%ContentType{} = post, attrs) do
    post
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end

  def swagger_definitions do
    use PhoenixSwagger
    %{
      content_type: JsonApi.resource do
        description "A content type"
        attributes do
          name :string, "the content type name", required: true
          description :string, "the content type description", required: true
        end
      end
    }
  end

  def name_for_id(id) do
    Repo.one! from q in ContentType,
      where: q.id == ^id,
      select: q.name
  end
end
