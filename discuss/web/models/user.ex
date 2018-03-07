defmodule Discuss.User do
    use Discuss.Web, :model

    schema "users" do
        field :provider, :string
        field :email, :string
        field :token, :string

        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:provider, :email, :token])
        |> validate_required([:provider, :email, :token])
    end
end