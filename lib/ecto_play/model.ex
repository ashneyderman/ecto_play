defmodule EctoPlay.Model do

  defmodule Base do
    def split_alias_and_field(aliased_field) do
      {_, acc} = Macro.postwalk(aliased_field, [], 
        fn
          ({a,_,_} = al, acc) when is_atom(a) and a != :. -> {al, [al|acc]}
          (f, acc) when is_atom(f) -> {f, [f|acc]}
          (n, acc) -> {n, acc}
        end) 
      acc |> Enum.reverse
    end

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
      [aliaz, feeld] = split_alias_and_field(aliased_field)
      quote do
        ns_eq(unquote(query), unquote(binds), {unquote(aliaz), unquote(feeld)}, unquote(value))
      end
    end

    defmacro ns_ilike(query,feeld,value) do
      quote do
        if unquote(value) == nil,
          do: unquote(query),
        else: where(unquote(query), 
                    [aliaz], 
                    ilike(field(aliaz,^unquote(feeld)), ^("%" <> unquote(value) <> "%")))
      end
    end

    defmacro ns_ilike(query,binds,{aliaz,feeld},value) do
      quote do
        if unquote(value) == nil, 
          do: unquote(query),
        else: where(unquote(query), 
                    unquote(binds), 
                    ilike(field(unquote(aliaz),^unquote(feeld)), ^("%" <> unquote(value) <> "%")))
      end
    end
    defmacro ns_ilike(query,binds,aliased_field,value) do
      [aliaz, feeld] = split_alias_and_field(aliased_field)
      quote do
        ns_ilike(unquote(query), unquote(binds), {unquote(aliaz), unquote(feeld)}, unquote(value))
      end
    end

    defmacro __using__(_) do
      quote do
        use Ecto.Model
        import Ecto.Query
        import EctoPlay.Model.Base
        alias EctoPlay.Repo
        require Logger

        def all(query), do: Repo.all(query)
        def one!(query), do: Repo.one!(query)
        def get(id), do: Repo.get(__MODULE__, id)
        def one(query), do: Repo.one(query)
        def update(rec), do: Repo.update(rec)
        
        def insert!(rec) when is_map(rec) do
          if Map.has_key?(rec, :__struct__) do
            unless Map.get(rec, :__struct__) == __MODULE__ do
              Logger.warn("""
                Calling insert on module #{inspect Map.get(rec, :__struct__)} that does 
                not match the caller module #{inspect __MODULE__}
              """)
            end
            Repo.insert!(rec)
          else
            Repo.insert!(struct(__MODULE__, rec))
          end
        end

        def delete(rec), do: Repo.delete(rec)
        def delete(type, id), do: Repo.delete(type, id)      
      end
    end 
  end

end


