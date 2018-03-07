defmodule Discuss.Router do
  use Discuss.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Discuss do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/home", PageController, :index
    # get "/topics", TopicsController, :index
    # get "/topics/new", TopicsController, :new
    get "/get-started", CodeController, :index
    # get "/topics/:id/edit", TopicsController, :edit

    # post "/topics", TopicsController, :create

    # put "/topics/:id", TopicsController, :update

    # delete "/topics/:id", TopicsController, :delete

    resources "/topics", TopicsController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Discuss do
  #   pipe_through :api
  # end
end
