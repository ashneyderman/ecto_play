defmodule EctoPlay.Meteo do
  
  defmodule Report do
    use EctoPlay.Model.Base

    schema "report" do
      field :name, :string
      field :month, :string
      timestamps
    end
  end

  defmodule Weather do
    use EctoPlay.Model.Base

    schema "weather" do
      field :city, :string
      field :temp_lo, :integer
      field :temp_hi, :integer
      field :prcp, :float, default: 0.0
      timestamps
      belongs_to :report, EctoPlay.Meteo.Report
    end

    def my_find0(opts) do
      (from w in EctoPlay.Meteo.Weather, select: w)
      |> ns_eq(:city, opts |> Dict.get(:city))
      |> ns_eq(:city, opts |> Dict.get(:prcp))
      |> all
    end

    def my_find1(opts) do
      (from w in EctoPlay.Meteo.Weather, 
        join: r in EctoPlay.Meteo.Report, on: w.report_id == r.id, 
        select: {w.city, r.name})
      |> ns_eq([w,r], w.city, opts |> Dict.get(:city))
      |> ns_eq([w,r], w.prcp, opts |> Dict.get(:prcp))
      |> ns_eq([w,r], r.name, opts |> Dict.get(:name))
      |> ns_eq([w,r], r.month, opts |> Dict.get(:month))
      |> all
    end

    def my_find2(opts) do
      q = (from w in EctoPlay.Meteo.Weather, 
             join: r in EctoPlay.Meteo.Report, on: w.report_id == r.id, 
             select: {w.city, r.name})
      q0 = [:city,:prcp] 
            |> Enum.reduce(q,  fn(field, query) -> 
                                 ns_eq(query, [w], {w,field}, opts |> Dict.get(field))
                               end)
      q1 = [:name, :month]
            |> Enum.reduce(q0, fn(field, query) ->
                                 IO.puts "field: #{field}" 
                                 ns_eq(query, [w,r], {r,field}, opts |> Dict.get(field))
                               end)
      q1 |> all
    end
  end

end