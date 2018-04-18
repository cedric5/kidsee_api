defmodule KidseeApi.Schemas.User do
  use KidseeApi.Schema
  alias KidseeApi.Schemas.User

  schema "user" do
    field :avatar, :string
    field :birthdate, :naive_datetime
    field :postal_code, :string
    field :email, :string
    field :password, :string
    field :school, :string
    field :username, :string

    timestamps()
  end

  def preload(query) do
    query
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :password, :email, :birthdate, :school, :postal_code, :avatar])
    |> validate_required([:username, :password, :email, :birthdate])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  def swagger_definitions do
    use PhoenixSwagger
    %{
      user: JsonApi.resource do
        description "A user"
        attributes do
          username :string, "The username", required: true
          email :string, "Email", required: true
          password :string, "Encrypted password of the user", required: true
          birthdate :naive_datetime, "Birthday in datetime format", required: true
          avatar :string, "An url to a png representing the avater"
          postal_code :string, "The postal code of the user's address"
          school :string, "Name of the school the user goes to"
        end
      end
    }
  end
end