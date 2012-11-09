command "dog" do
  matches "dog"

  subcommand "xkcd" do
    matches "xkcd"
    action do
      uri = URI.parse "http://xkcd.com/info.0.json"
      comic = JSON.parse uri.open.read
      "#{comic["img"]}\n#{comic["alt"]}"
    end
  end
end
