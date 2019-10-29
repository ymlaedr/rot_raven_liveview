defmodule RotRaven.Mongo do
  @moduledoc """
  Mongoに対して基本的なCRUDを行うモジュール
  """

  def all(module) do
    module
    |> get_schema_name()
    |> (&Mongo.find(:mongo, &1, %{})).()
  end

  def all(module, limit) do
    module
    |> get_schema_name()
    |> (&Mongo.find(:mongo, &1, %{}, limit: limit)).()
  end

  def find(module, opts \\ %{}) do
    module
    |> get_schema_name()
    |> (&Mongo.find(:mongo, &1, %{})).()
  end

  def insert(%{} = map, module, opts), do: do_insert(map, module |> get_schema_name(), opts)
  def insert(struct, module, opts \\ %{}), do: do_insert(struct |> Map.from_struct(), module |> get_schema_name(), opts)
  def do_insert(doc, coll, opts \\ %{}) do
    :mongo
    |> Mongo.insert_one(coll, doc)
  end

  defp get_schema_name(module), do: module.__schema__(:source)
end
