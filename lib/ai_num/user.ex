defmodule AiNum.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias AiNum.Repo
  require Logger

  schema "users" do
    field :number, :string
    field :transcript, :string
    field :text_count, :integer, default: 0
    field :image_count, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:number, :transcript, :text_count, :image_count])
    |> validate_required([:number])
    |> unique_constraint(:number)
  end

  def create_or_find(number) do
    user = __MODULE__ |> Repo.get_by(number: number)

    user =
      if !user do
        {:ok, user} = %AiNum.User{number: number} |> Repo.insert()
        Logger.debug("Created user")
        user
      else
        user
      end

    user
  end

  def text_count_inc(user) do
    user
    |> cast(%{text_count: user.text_count + 1}, [:text_count])
    |> Repo.update()
  end

  def image_count_inc(user) do
    user
    |> cast(%{image_count: user.image_count + 1}, [:image_count])
    |> Repo.update()
  end

  def total_image_count do
    __MODULE__ |> Repo.aggregate(:sum, :image_count)
  end

  def total_text_count do
    __MODULE__ |> Repo.aggregate(:sum, :text_count)
  end

  def total_user_count do
    __MODULE__ |> Repo.aggregate(:count, :id)
  end
end
