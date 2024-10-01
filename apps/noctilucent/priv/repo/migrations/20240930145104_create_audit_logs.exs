defmodule Noctilucent.Repo.Migrations.CreateAuditLogs do
  use Ecto.Migration

  def change do
    create table(:audit_logs) do
      add :verb, :string
      add :scope, :string
      add :ip_addr, :string
      add :user_agent, :string
      add :context, :map
      add :params, :map
      add :user, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:audit_logs, [:user])
  end
end
