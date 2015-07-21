defmodule EctoPlay.Repo.Migrations.League do
  use Ecto.Migration

  def change do
    create table(:country) do
      add :name, :string
      add :iso_code, :string
      timestamps
    end
    
    create table(:team) do
      add :name, :string
      add :city, :string
      timestamps
    end

    create table(:player) do
      add :name,  :string
      add :title, :string
      add :country_id, references(:country)
      timestamps
    end

    create table(:coach) do
      add :name,  :string
      add :title, :string
      add :country_id, references(:country)
      timestamps
    end
    
    create table(:team_member) do
      add :team_id, references(:team)
      add :player_id, references(:player)
      add :coach_id, references(:coach)
      timestamps
    end

  end
end