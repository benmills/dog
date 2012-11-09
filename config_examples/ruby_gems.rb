command "dog" do
  matches "dog"

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
end
