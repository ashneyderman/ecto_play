defmodule EctoPlay.League do

  defmodule Country do
    use EctoPlay.Model.Base

    schema "country" do
      field :name, :string
      field :iso_code, :string
      timestamps
    end

    def find_by_iso_code(iso_code) do
      (from c in EctoPlay.League.Country,
        where: c.iso_code == ^iso_code,
        select: c) |> one!
    end
  end

  defmodule Team do
    use EctoPlay.Model.Base

    schema "team" do
      field :name, :string
      field :city, :string
      has_many :members, EctoPlay.League.TeamMember
      has_many :players, through: [:members, :player]
      has_many :coaches, through: [:members, :coach]
      timestamps
    end

    def search(params) do
      (from t in EctoPlay.League.Team,
        distinct: true,
        preload: [[coaches: :country],[players: :country]],
        select: t)
      |> ns_eq(:name, params |> Dict.get(:name))
      |> ns_eq(:city, params |> Dict.get(:city))
      |> all
    end
  end

  defmodule TeamMember do
    use EctoPlay.Model.Base

    schema "team_member" do
      belongs_to :team, EctoPlay.League.Team
      belongs_to :player, EctoPlay.League.Player
      belongs_to :coach, EctoPlay.League.Coach
      timestamps
    end    
  end

  defmodule Player do
    use EctoPlay.Model.Base

    schema "player" do
      field :name, :string
      field :title, :string
      belongs_to :country, EctoPlay.League.Country
      timestamps
    end
  end

  defmodule Coach do  
    use EctoPlay.Model.Base

    schema "coach" do
      field :name, :string
      field :title, :string
      belongs_to :country, EctoPlay.League.Country
      timestamps
    end
  end
  
end