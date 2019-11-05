# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RotRaven.Repo.insert!(%RotRaven.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# [
#   %{
#     module: RotRaven.Vehicle.GpsRecord,
#     collection: %{
#       :accuracy => 2777,
#       :altitude => nil,
#       :altitude_accuracy => nil,
#       :heading => nil,
#       :latitude => 33.9113796,
#       :longitude => 130.9485807,
#       :speed => nil,
#       :speed_measurement => "hybeni",
#       :timestamp => "2019-10-29T15:30:47.451Z"
#     }
#   }
# ]
# |> Enum.each(&( RotRaven.Mongo.insert(&1.collection, &1.module) ))


"priv/repo/seeds/json/vehicle_gps_records.json"
|> File.read!()
|> Poison.decode!()
|> Enum.each(&( RotRaven.Mongo.insert(&1, RotRaven.Vehicle.GpsRecord) ))
