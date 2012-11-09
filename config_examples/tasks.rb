task "say hi" do |t|
  t.every "60m"
  t.action { "hello all!" }
end
