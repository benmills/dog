command "dog" do
  matches "dog"

  subcommand "fetch image" do
    matches "fetch", "image"
    action do |message|
      query = message.split(" ")[2..-1].join(" ")
      GoogleImageApi.find(query).images.first["url"]
    end
  end
end
