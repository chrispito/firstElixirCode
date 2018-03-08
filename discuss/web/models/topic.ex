defmodule Discuss.Topic do
    use Discuss.Web, :model

    schema "topics" do
        field :title, :string
        field :description, :string

        belongs_to :user, Discuss.User
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:title, :description])
        |> validate_required([:title, :description])
    end
end