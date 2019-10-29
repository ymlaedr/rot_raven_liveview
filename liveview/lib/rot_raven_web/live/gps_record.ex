defmodule RotRavenWeb.GpsRecord do
  use Phoenix.LiveView

  alias RotRaven.Vehicle.GpsRecord

  def render(assigns) do
    ~L"""
      <p>GPSロガーもどき</p>
      <button id="control_button" onClick="loggingControl()">開始</button>
      <form phx-submit="submit">
        <input type="hidden" name="records_json" value="" />
        <input type="submit" id="upload_button" />
      </form>
      <table>
      <tr>
        <th>取得日時</th>
        <th>緯度</th>
        <th>経度</th>
        <th>高度</th>
        <th>経度・緯度の誤差</th>
        <th>高度の誤差</th>
        <th>方角</th>
        <th>速度(km/h)</th>
        <th>速度の計測方法</th>
      </tr>
      <tr>
        <td id="timestamp_display"></td>
        <td id="latitude_display"></td>
        <td id="longitude_display"></td>
        <td id="altitude_display"></td>
        <td id="accuracy_display"></td>
        <td id="altitude_accuracy_display"></td>
        <td id="heading_display"></td>
        <td id="speed_display"></td>
        <td id="speed_measurement_display"></td>
      </tr>
      <%= for record <- @records do %>
      <tr>
        <td><%= record["timestamp"] %></td>
        <td>
          <a href="https://www.google.com/maps?q=<%= record["latitude"] %>,<%= record["longitude"] %>" target="_blank">
            <%= record["latitude"] %>
          </a>
        </td>
        <td>
          <a href="https://www.google.com/maps?q=<%= record["latitude"] %>,<%= record["longitude"] %>" target="_blank">
            <%= record["longitude"] %>
          </a>
        </td>
        <td><%= record["altitude"] %></td>
        <td><%= record["accuracy"] %></td>
        <td><%= record["altitude_accuracy"] %></td>
        <td><%= record["heading"] %></td>
        <td><%= record["speed"] %></td>
        <td><%= record["speed_measurement"] %></td>
      </tr>
      <% end %>
    </table>
      <script>
        var records = [];
        var wpid = null;
        function loggingControl() {
          if(wpid === null) {
            startGpsLogging();
            document.getElementById("control_button").innerText = "終了";
            document.getElementById("upload_button").disabled = true;
          } else {
            stopGpsLogging();
            document.getElementById("control_button").innerText = "開始";
            document.getElementById("upload_button").disabled = false;
          }
        }
        // 監視を始めるとき
        function startGpsLogging() {
          wpid = navigator.geolocation.watchPosition(
            (position) => {
              // 成功時の処理
              let coords = {
                timestamp: new Date().toJSON(),
                // message: "ok.",
                accuracy: position.coords.accuracy,
                altitude: position.coords.altitude,
                altitude_accuracy: position.coords.altitudeAccuracy,
                heading: position.coords.heading,
                latitude: position.coords.latitude,
                longitude: position.coords.longitude,
                speed: position.coords.speed * 60 * 60 / 1000,
                speed_measurement: (position.coords.speed === null) ? "hybeni" : "sensor"
              };
              records[records.length] = coords;
              Object.keys(coords).forEach((key) => {
                document.getElementById(key + "_display").innerText = coords[key];
              });
            },
            (error) => {
              // 失敗時の処理
              coords.timestamp = new Date().toJSON();
              coords.message = "gps unavailable. error_code:" + error.code + " error_message:" + error.message;
            },
            {
              enableHighAccuracy: true,
              maximumAge        : 30000,
              timeout           : 27000
            }
          );
        }
        // 止めるとき
        function stopGpsLogging() {
          navigator.geolocation.clearWatch(wpid);
          wpid = null;
          document.getElementsByName("records_json")[0].value = JSON.stringify(records);
        }
      </script>
    """
  end

  def mount(_session, socket) do
    {
      :ok,
      assign(socket, records: GpsRecord.get_all_gpsrecord(), records_json: "")
    }
  end

  def handle_event("submit", %{"records_json" => records_json}, socket) do
    IO.inspect("handle_event function called.")
    send(self(), {:submit, records_json})
    {:noreply, assign(socket, records: [], records_json: records_json)}
  end

  def handle_info({:submit, records_json}, socket) do
    IO.inspect("handle_info function called.")

    records_json
    |> Poison.decode!()
    |> Enum.each(&( RotRaven.Mongo.insert(&1, RotRaven.Vehicle.GpsRecord) ))

    {:noreply, assign(socket, records: Poison.decode!(records_json))}
  end
end
