defmodule Discuss.TopicsController do
  use Discuss.Web, :controller
  alias Discuss.Topic
  alias Discuss.Router.Helpers

  plug Discuss.Plugs.RequireAuth when action in [
    :new,
    :create,
    :edit,
    :update,
    :delete
  ]
  plug :check_topic_owner when action in [
    :update,
    :edit,
    :delete
  ]

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def show(conn, %{"id" => topic_id}) do
    topic = Topic
            |> Repo.get!(topic_id)
            |> Repo.preload(:comments)
            
    changeset = Topic.changeset(topic)
    # case Repo.get!(Topic, topic_id) do
    #   {:ok, topic} ->
    #     topic_to_show = topic 
    #   {:error, changeset} ->
    #     conn
    #     |> put_flash(:error, "The Topic you are trying to see doesn't exist!")
    #     |> redirect(to: topics_path(conn, :index))
    # end
    # render conn, "show.html", topic: topic_to_show
    render conn, "show.html", changeset: changeset, topic: topic
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render conn, "new.html", changeset: changeset, title_error: nil, desc_error: nil, title_class: "form-controll", desc_class: "materialize-textarea"
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get!(Topic, topic_id)
    changeset = Topic.changeset(topic)
    render conn, "edit.html", changeset: changeset, topic: topic, title_error: nil, desc_error: nil, title_class: "form-controll", desc_class: "materialize-textarea"
  end

  def create(conn, %{"topic" => topic}) do

    changeset = conn.assigns.user
                |> build_assoc(:topics)
                |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, _topic} -> 
        conn
        |> put_flash(:info, "You have successfully created a new Topic")
        |> redirect(to: topics_path(conn, :index))
      {:error, changeset} ->
        [desc_class, desc_error] =
          case Keyword.has_key?(changeset.errors, :description) do
            false -> 
              ["materialize-textarea", nil]
            true -> 
              [{desc_error, _val}]  = Keyword.get_values(changeset.errors, :description)
              ["materialize-textarea invalid", desc_error]
          end
        
        [title_class, title_error] =
          case Keyword.has_key?(changeset.errors, :title) do
            false -> 
              ["form-controll", nil]
            true -> 
              [{title_error, _val}] = Keyword.get_values(changeset.errors, :title)
              ["form-controll invalid", title_error]
          end
        render conn, "new.html", changeset: changeset, title_error: title_error, desc_error: desc_error, title_class: title_class, desc_class: desc_class
    end
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get!(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)
    case Repo.update(changeset) do
      {:ok, _topic} -> 
        conn
        |> put_flash(:info, "You have successfully updated your Topic")
        |> redirect(to: topics_path(conn, :index))
      {:error, changeset} ->
        [desc_class, desc_error] =
          case Keyword.has_key?(changeset.errors, :description) do
            false -> 
              ["materialize-textarea", nil]
            true -> 
              [{desc_error, _val}]  = Keyword.get_values(changeset.errors, :description)
              ["materialize-textarea invalid", desc_error]
            end
        [title_class, title_error] =
          case Keyword.has_key?(changeset.errors, :title) do
            false -> 
              ["form-controll", nil]
            true -> 
              [{title_error, _val}] = Keyword.get_values(changeset.errors, :title)
              ["form-controll invalid", title_error]
          end
        render conn, "edit.html", changeset: changeset, topic: old_topic, title_error: title_error, desc_error: desc_error, title_class: title_class, desc_class: desc_class
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.get!(Topic, topic_id)
    |> Repo.delete!

    conn
    |> put_flash(:info, "Topic successfully deleted!")
    |> redirect(to: topics_path(conn, :index))
  end

  def check_topic_owner(%{params: %{"id" => topic_id}} = conn, _params) do
    if Repo.get(Topic, topic_id).user_id == conn.assigns[:user].id do
      conn
    else
      conn
      |> put_flash(:error, "You need to logged in!")
      |> redirect(to: Helpers.topics_path(conn, :index))
      |> halt()
    end
  end

end
