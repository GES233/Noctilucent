defmodule Noctilucent.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :nickname, :string
      add :username, :string, null: false
      add :hashed_password, :string, null: false
      add :gender, :string
      add :gender_visible, :boolean, default: false, null: false
      add :avater, :string
      add :status, :string, null: false
      add :current, :string
      add :info, :string

      timestamps()
    end

    create unique_index(:users, [:username])
    create index(:users, [:nickname])

    create table(:user_tokens) do
      add :token, :binary, null: false
      add :context, :string, null: false
      add :type, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:user_tokens, [:user_id])
    create unique_index(:user_tokens, [:context, :type, :token])
  end
end
