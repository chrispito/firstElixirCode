defmodule Discuss.Topic do
    use Discuss.Web, :model

    # @derive {Poison.Encoder, only: [:title, :description]}

    schema "topics" do
        field :title, :string
        field :description, :string

        belongs_to :user, Discuss.User
        has_many :comments, Discuss.Comment
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:title, :description])
        |> validate_required([:title, :description])
    end
end