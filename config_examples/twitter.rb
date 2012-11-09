command "get body of tweet" do
  matches /twitter\.com/
  action do |message|
    id = message.split("/").last
    uri = URI.parse "https://api.twitter.com/1/statuses/show.json?id=#{id}"
    tweet = JSON.parse uri.open.read

    "#{tweet["text"]} - @#{tweet["user"]["screen_name"]}"
  end
end
