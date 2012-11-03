chat_rooms "dog_test", "dog_test2"

command "get body of tweet" do
  matches /twitter\.com/
  action do |message|
    id = message.split("/").last
    uri = URI.parse "https://api.twitter.com/1/statuses/show.json?id=#{id}"
    tweet = JSON.parse uri.open.read

    "#{tweet["text"]} - @#{tweet["user"]["screen_name"]}"
  end
end

command "dog" do
  matches "dog"
  action { "bark!" }

  subcommand "xkcd" do
    matches "xkcd"
    action do
      uri = URI.parse "http://xkcd.com/info.0.json"
      comic = JSON.parse uri.open.read
      "#{comic["img"]}\n#{comic["alt"]}"
    end
  end

  subcommand "fetch image" do
    matches "fetch", "image"
    action do |message|
      query = message.split(" ")[2..-1].join(" ")
      GoogleImageApi.find(query).images.first["url"]
    end
  end

  subcommand "ruby gems" do
    matches "gem"
    action do |message|
      begin
        gem_name = message.split(" ").last
        uri = URI.parse "http://rubygems.org/api/v1/gems/#{gem_name}.json"
        gem = JSON.parse uri.open.read

        "'#{gem["name"]}' version: #{gem["version"]} downloads: #{gem["downloads"]}"
      rescue
        "gem not found"
      end
    end
  end

  subcommand "join channel" do
    matches "join"
    action { :join }
  end

  subcommand "reload config" do
    matches "reload"
    action { :reload }
  end
end
