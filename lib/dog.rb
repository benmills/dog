require "rubygems"
require "blather/client"
require "blather/stanza"
require "twitter"

require_relative "dog/configure"
require_relative "dog/command"

@commands = []

def respond_to text
  @commands.each do |command|
    response = command.respond_to text
    return response unless response.nil?
  end

  "bark?"
end

def respond_to_action body, kind
  case kind
  when :join then
    join("#{body.split.last}@conference.#{client.jid.domain}", client.jid.node)
    "joined #{body.split.last}"
  when :reload then
    reload_config
    "config reloaded"
  else "invalid action"
  end
end

def process body
  response = respond_to body

  if response.is_a? Symbol
    respond_to_action body, response
  else
    response
  end
rescue => e
  puts e
  "sorry, there was an error"
end

def reload_config
  raise "Need 'CONFIG_PATH' env var" unless ENV.has_key? "CONFIG_PATH"

  config = File.read ENV["CONFIG_PATH"]
  @commands = Dog::Configure.parse config
end

when_ready do
  reload_config
end

subscription(:request?) { |s| write_to_stream s.approve! }

message :groupchat?, :body do |m|
  pass if m.from == "foo@conference.#{client.jid.domain}/#{client.jid.node}" || m.delayed?
  say Blather::JID.new("foo", "conference.localhost"), process(m.body), :groupchat
end

message :chat?, :body do |m|
  say m.from, process(m.body)
end
