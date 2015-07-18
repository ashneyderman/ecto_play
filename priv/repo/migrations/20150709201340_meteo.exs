defmodule EctoPlay.Repo.Migrations.Meteo do
  use Ecto.Migration

  def change do
    create table(:report) do
      add :name,  :string
      add :month, :string, size: 7
      timestamps
    end
    
    create table(:weather) do
      add :city,    :string, size: 40
      add :temp_lo, :integer
      add :temp_hi, :integer
      add :prcp,    :float
      add :report_id, references(:report)
      timestamps
    end
  end

end
