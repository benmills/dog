command "dog" do
  matches "dog"
  action { "bark!" }

  subcommand "join channel" do
    matches "join"
    action { :join }
  end

  subcommand "reload config" do
    matches "reload"
    action { :reload }
  end
end
