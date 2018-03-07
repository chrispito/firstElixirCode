defmodule Discuss.Topic do
    use Discuss.Web, :model

    schema "topics" do
        field :title, :string
        field :description, :string
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:title, :description])
        |> validate_required([:title, :description])
    end
end