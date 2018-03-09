defmodule Discuss.User do
    use Discuss.Web, :model

    @derive {Poison.Encoder, only: [:name, :email]}

    schema "users" do
        field :provider, :string
        field :email, :string
        field :token, :string
        field :name, :string

        has_many :topics, Discuss.Topic
        has_many :comments, Discuss.Comment
        
        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:provider, :name, :email, :token])
        |> validate_required([:provider, :name, :email, :token])
    end
end