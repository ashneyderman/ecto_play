defmodule EctoPlay.League do

  defmodule Team do
    use EctoPlay.Model.Base

    schema "team" do
      field :name, :string
      field :city, :string
      has_many :members, EctoPlay.League.TeamMember
      has_many :players, EctoPlay.League.Player
      has_many :coaches, EctoPlay.League.Coach
      timestamps
    end
  end

  defmodule TeamMember do
    use EctoPlay.Model.Base

    schema "team_member" do
      field :first_season, :string
      belongs_to :team, EctoPlay.League.Team
      belongs_to :player, EctoPlay.League.Player
      belongs_to :coach, EctoPlay.League.Coach
      timestamps
    end    
  end

  defmodule Player do
    use EctoPlay.Model.Base

    schema "palyer" do
      field :name, :string
      field :title, :string
    end
  end

  defmodule Coach do  
    use EctoPlay.Model.Base

    schema "coach" do
      field :name, :string
      field :title, :string
      belongs_to :team_member, EctoPlay.League.TeamMember
    end
  end
  
end