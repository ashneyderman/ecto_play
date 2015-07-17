defmodule EctoPlay.Model do

  defmodule Base do
    def split_alias_and_field(query) do
      {_, acc} = Macro.postwalk(query, [], 
        fn
          ({a,_,_} = al, acc) when is_atom(a) and a != :. -> {al, [al|acc]}
          (f, acc) when is_atom(f) -> {f, [f|acc]}
          (n, acc) -> {n, acc}
        end) 
      acc |> Enum.reverse
    end

    defmacro __using__(_) do
      quote do
        use Ecto.Model
        import Ecto.Query
        import EctoPlay.Model.Base
        alias EctoPlay.Repo

        def all(query), do: Repo.all(query)
        def one!(query), do: Repo.one!(query)
        def get(id), do: Repo.get(__MODULE__, id)
        def one(query), do: Repo.one(query)
        def update(rec), do: Repo.update(rec)
        def insert(rec), do: Repo.insert(rec)
        def delete(rec), do: Repo.delete(rec)
        def delete(type, id), do: Repo.delete(type, id)
        
        defmacro ns_eq(query,feeld,value) do
          quote do
            if unquote(value) == nil,
              do: unquote(query),
            else: where(unquote(query), 
                        [aliaz], 
                        field(aliaz, ^unquote(feeld)) == ^unquote(value))
          end
        end

        defmacro ns_eq(query,binds,{aliaz,feeld},value) do
          quote do
            if unquote(value) == nil, 
              do: unquote(query),
            else: where(unquote(query), 
                        unquote(binds), 
                        field(unquote(aliaz), ^unquote(feeld)) == ^unquote(value))
          end
        end
        defmacro ns_eq(query,binds,aliased_field,value) do
          [aliaz, feeld] = EctoPlay.Model.Base.split_alias_and_field(aliased_field)
          quote do
            ns_eq(unquote(query), unquote(binds), {unquote(aliaz), unquote(feeld)}, unquote(value))
          end
        end
      end
    end 
  end

end


