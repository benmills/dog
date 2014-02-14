command "dog" do
  matches "dog"

  subcommand "show available commands" do
    matches "dog help", "man dog"
    action { :help }
  end
end
