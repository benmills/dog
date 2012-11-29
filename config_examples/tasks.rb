task "say hi" do |t|
  t.every "50m"
  t.action { "hello all!" }
end
