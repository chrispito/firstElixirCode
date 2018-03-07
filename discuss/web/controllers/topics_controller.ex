defmodule Discuss.TopicsController do
  use Discuss.Web, :controller
  alias Discuss.Topic

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
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
    changeset = Topic.changeset(%Topic{}, topic)
    case Repo.insert(changeset) do
      {:ok, topic} -> 
        conn
        |> put_flash(:info, "You have successfully created a new Topic")
        |> redirect(to: topics_path(conn, :index))
      {:error, changeset} ->
        case Keyword.has_key?(changeset.errors, :description) do
          false -> desc_class = "materialize-textarea"
          true -> 
            [{desc_error, val}]  = Keyword.get_values(changeset.errors, :description)
            desc_class = "materialize-textarea invalid"
        end
        case Keyword.has_key?(changeset.errors, :title) do
          false -> title_class = "form-controll"
          true -> 
            [{title_error, val}] = Keyword.get_values(changeset.errors, :title)
            title_class = "form-controll invalid"
        end
        render conn, "new.html", changeset: changeset, title_error: title_error, desc_error: desc_error, title_class: title_class, desc_class: desc_class
    end
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get!(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)
    case Repo.update(changeset) do
      {:ok, topic} -> 
        conn
        |> put_flash(:info, "You have successfully updated your Topic")
        |> redirect(to: topics_path(conn, :index))
      {:error, changeset} ->
        case Keyword.has_key?(changeset.errors, :description) do
          false -> desc_class = "materialize-textarea"
          true -> 
            [{desc_error, val}]  = Keyword.get_values(changeset.errors, :description)
            desc_class = "materialize-textarea invalid"
        end
        case Keyword.has_key?(changeset.errors, :title) do
          false -> title_class = "form-controll"
          true -> 
            [{title_error, val}] = Keyword.get_values(changeset.errors, :title)
            title_class = "form-controll invalid"
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
end