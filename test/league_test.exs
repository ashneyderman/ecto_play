defmodule EctoPlay.LeagueTest do
  use ExUnit.Case
  alias EctoPlay.Repo
  alias EctoPlay.League.Team
  alias EctoPlay.League.TeamMember
  alias EctoPlay.League.Player
  alias EctoPlay.League.Coach
  alias EctoPlay.League.Country
  require Logger

  setup_all do
    cleanup_fixtures
    create_fixtures
    {:ok, []}
  end

  test "assert countries" do
    countries = Country.all(Country)
    Logger.debug "countres: #{Enum.join((for c <- countries, do: c.name), ", ")}"
    assert length(countries) == 6
  end

  test "team search" do
    [t0,t1] = Team.search([zip: "terter"])
    print_team(t0)
    print_team(t1)
  end

  defp print_team(team) do
    f = fn(collection) ->
          for rec <- collection do
            cname = if rec.country, do: rec.country.name, else: "Unknown"
            Logger.debug "#{rec.name} (#{rec.title}): #{cname}"
          end
        end
    
    Logger.debug "#{team.name}"
    f.(team.coaches)
    f.(team.players)
  end

  defp create_fixtures do
    rus = Country.insert!(%{name: "Russia", iso_code: "RUS"})
    can = Country.insert!(%{name: "Canada", iso_code: "CAN"})
    usa = Country.insert!(%{name: "USA",    iso_code: "USA"})
    swe = Country.insert!(%{name: "Sweden", iso_code: "SWE"})
    _fin = Country.insert!(%{name: "Finland", iso_code: "FIN"})
    _cze = Country.insert!(%{name: "Chech Republic", iso_code: "CZE"})

    # teams
    wash = Team.insert!(%{name: "Washington Capitals", city: "Washington DC"})
    detr = Team.insert!(%{name: "Detroit Red Wings"  , city: "Detroit"})

    # coaches
    btrotz   = Coach.insert!(%{name: "Barry Totz"  , title: "Head Coach"})
    mbabcock = Coach.insert!(%{name: "Mike Babcock", title: "Head Coach"})

    # players
    aovechkn = Player.insert!(%{name: "Alex Ovechkin", title: "LW Forward", country_id: rus.id})
    nbackstr = Player.insert!(%{name: "Niklaus Backstrom", title: "Center", country_id: swe.id})
    jbeagle  = Player.insert!(%{name: "Jay Beagle", title: "RW Forward", country_id: can.id})
    
    pdatsyuk = Player.insert!(%{name: "Pavel Datsyuk", title: "Center", country_id: rus.id})
    hzetterb = Player.insert!(%{name: "Henri Zertterberg", title: "LW Forward", country_id: usa.id})
    ttatar   = Player.insert!(%{name: "Tomas Tatar", title: "LW Forward", country_id: can.id})

    # memberships
    TeamMember.insert!(%{ team_id: wash.id, player_id: aovechkn.id })
    TeamMember.insert!(%{ team_id: wash.id, player_id: nbackstr.id })
    TeamMember.insert!(%{ team_id: wash.id, player_id: jbeagle.id })
    TeamMember.insert!(%{ team_id: wash.id, coach_id: btrotz.id })

    TeamMember.insert!(%{ team_id: detr.id, player_id: pdatsyuk.id })
    TeamMember.insert!(%{ team_id: detr.id, player_id: hzetterb.id })
    TeamMember.insert!(%{ team_id: detr.id, player_id: ttatar.id })
    TeamMember.insert!(%{ team_id: detr.id, coach_id: mbabcock.id })
  end

  defp cleanup_fixtures do
    for t <- [TeamMember,Player,Coach,Country,Team] do
      for r <- Repo.all(t), do: Repo.delete(r)
    end
  end

end