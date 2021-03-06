defmodule Carbon.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password_reset_token, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    
    timestamps
  end

  def changeset(:create, user, params) do
    user
    |> cast(params, [:email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> hash_password()
  end

  def changeset(:password_reset, user, params) do
    user
    |> cast(params, [:email])
    |> validate_required([:email])
    |> generate_reset_token()
  end

  def changeset(:password_update, user, params) do
    user
    |> cast(params, [:password, :password_confirmation])
    |> validate_required([:password])
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> hash_password()
  end

  def changeset(user, params \\ %{})
  def changeset(user, params) do
    user
    |> cast(params, [:email, :password_hash])
    |> validate_required([:email, :password_hash])
  end

  def hash_password(changeset) do
    password = get_change(changeset, :password)
    password_hash = Carbon.password_hash(password)
    put_change(changeset, :password_hash, password_hash)
  end

  def generate_reset_token(changeset) do
    token = Carbon.password_reset_token
    put_change(changeset, :password_reset_token, token)
  end
end
