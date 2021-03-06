
defmodule KidseeApi.Schemas.Assignment do
    use KidseeApi.Schema
    alias KidseeApi.Schemas.{Assignment, AssignmentType, AnswerType, Location}

    schema "assignment" do
      field :name, :string
      field :description, :string
      field :content, :string
      field :rating, :float
      field :completed, :boolean, virtual: true, default: false

      belongs_to :answer_type, AnswerType
      belongs_to :location, Location
      belongs_to :assignment_type, AssignmentType
      timestamps()
    end

    def preload(query) do
      from q in query,
        preload: [
          :assignment_type,
          :answer_type,
          location: ^Repo.preload_schema(Location)
        ]
    end

    @doc false
    def changeset(%Assignment{} = assignment, attrs) do
      assignment
      |> cast(attrs, [:name, :description, :content, :location_id, :assignment_type_id])
      |> validate_required([:name, :description, :content, :location_id , :assignment_type_id])
      |> unique_constraint(:name)
    end

    def swagger_definitions do
      use PhoenixSwagger
      %{
        assignment: JsonApi.resource do
          description "A assginment"
          attributes do
            name :string, "the assignment name", required: true
            content :string, "the assignment content", required: true
            description :string, "the assignment description", required: true
          end
          relationship :location
          relationship :assignment_type
        end
      }
    end
  end
