defmodule RotRaven.Vehicle.GpsRecord do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicle_gps_records" do
    field :timestamp, :utc_datetime, null: false
    field :status_message, :string
    field :accuracy, :decimal
    field :altitude, :integer, null: false
    field :altitude_accuracy, :decimal
    field :heading, :decimal, default: 0.0
    field :latitude, :decimal, null: false
    field :longitude, :decimal, null: false
    field :speed, :decimal
    field :speed_measurement, :string, size: 10, null: false, default: "hybeni"

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = gps_record, attrs \\ %{}) do
    gps_record
    |> cast(attrs, [
      :timestamp,
      :status_message,
      :latitude,
      :longitude,
      :altitude,
      :accuracy,
      :altitude_accuracy,
      :heading,
      :speed,
      :speed_measurement
    ])
    |> validate_required([
      :timestamp,
      :latitude,
      :longitude,
      :speed_measurement
    ])
    |> validate_number(
      :latitude,
      greater_than_or_equal_to: Decimal.new(-90),
      less_than_or_equal_to: Decimal.new(90)
    )
    |> validate_number(
      :longitude,
      greater_than_or_equal_to: Decimal.new(-180),
      less_than_or_equal_to: Decimal.new(180)
    )
    |> validate_number(
      :heading,
      greater_than_or_equal_to: Decimal.new(0),
      less_than_or_equal_to: Decimal.new(360)
    )
  end

  @doc false
  def get_all_gpsrecord() do
    __MODULE__
    |> RotRaven.Mongo.all()
  end
end
