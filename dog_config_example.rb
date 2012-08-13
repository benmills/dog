task "say hi" do |t|
  t.every "10min"
  t.action { "Hello world!" }
end

command "get body of tweet" do |c|
  c.matches /twitter\.com/
  c.action do |message|
    id = message.split("/").last
    uri = URI.parse "https://api.twitter.com/1/statuses/show.json?id=#{id}"
    tweet = JSON.parse uri.open.read

    "#{tweet["text"]} - @#{tweet["user"]["screen_name"]}"
  end
end

command "dog" do |c|
  c.matches "dog"
  c.action { "bark!" }

  c.subcommand "xkcd" do |sc|
    sc.matches "xkcd"
    sc.action do
      uri = URI.parse "http://xkcd.com/info.0.json"
      comic = JSON.parse uri.open.read
      "#{comic["img"]}\n#{comic["alt"]}"
    end
  end

  c.subcommand "fetch image" do |sc|
    sc.matches "fetch", "image"
    sc.action do |message|
      query = message.split(" ")[2..-1].join(" ")
      GoogleImageApi.find(query).images.first["url"]
    end
  end

  c.subcommand "ruby gems" do |sc|
    sc.matches "gem"
    sc.action do |message|
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

  c.subcommand "join channel" do |sc|
    sc.matches "join"
    sc.action { :join }
  end

  c.subcommand "reload config" do |sc|
    sc.matches "reload"
    sc.action { :reload }
  end
end
