defmodule EctoPlay.Base do

  defmacro __using__(_) do
    quote do
      use Ecto.Model
      import Ecto.Query
      import EctoPlay.Base
      alias EctoPlay.Repo

      def all(query), do: Repo.all(query)
      def one!(query), do: Repo.one!(query)
      def get(id), do: Repo.get(__MODULE__, id)
      def one(query), do: Repo.one(query)
      def update(rec), do: Repo.update(rec)
      def insert(rec), do: Repo.insert(rec)
      def delete(rec), do: Repo.delete(rec)
      def delete(type, id), do: Repo.delete(type, id)
      
      defmacro ns_eq(q,{a,f},v) do
        quote do
          if unquote(v) == nil, 
              do: unquote(q),
            else: where(unquote(q), [w,r], field(unquote(a),^unquote(f)) == ^unquote(v))
        end
      end
      # defmacro ns_eq(q,f,v) do
      #   quote do
      #     if unquote(v) == nil do
      #       unquote(q)
      #     else
      #       where(unquote(q),[w],field(w,^unquote(f)) == ^unquote(v))
      #     end
      #   end
      # end

    end
  end
  
end

defmodule EctoPlay.Report do
  use EctoPlay.Base

  schema "report" do
    field :name, :string
    field :month, :string
    timestamps
  end

end

defmodule EctoPlay.Weather do
  use EctoPlay.Base

  schema "weather" do
    field :city, :string
    field :temp_lo, :integer
    field :temp_hi, :integer
    field :prcp, :float, default: 0.0
    timestamps
    belongs_to :report, EctoPlay.Report
  end

  # def my_find(opts) do
  #   q = (from w in EctoPlay.Weather, select: w)
  #   [:city,:prcp] 
  #     |> Enum.reduce(q, &(ns_eq(&2, &1, opts |> Dict.get(&1))))
  #     |> all
  # end

  # def my_find1(opts) do
  #   q = (from w in EctoPlay.Weather, select: w)
  #   [:city,:prcp] 
  #     |> Enum.reduce(q, fn(field, query) -> 
  #                         ns_eq(query, {w,field}, opts |> Dict.get(field))
  #                       end)
  #     |> all
  # end

  def my_find2(opts) do
    q = (from w in EctoPlay.Weather, 
           join: r in EctoPlay.Report, on: w.report_id == r.id, 
           select: {w.city, r.name})

    q0 = [:city,:prcp] 
          |> Enum.reduce(q,  fn(field, query) -> 
                               ns_eq(query, {w,field}, opts |> Dict.get(field))
                             end)

    IO.puts "q0: #{inspect(q0, struct: false)}"

    q1 = [:name, :month]
          |> Enum.reduce(q0, fn(field, query) ->
                               IO.puts "field: #{field}" 
                               ns_eq(query, {r,field}, opts |> Dict.get(field))
                             end)

    IO.puts "q1: #{inspect(q1, struct: false)}"

    q1 |> all
  end

  # defp t(opts) do
  #   fn(field, query) -> 
  #     ns_eq(query, {w,field}, opts |> Dict.get(field))
  #   end)
  # end

end

