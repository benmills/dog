require "rubygems"
require "blather/client"
require 'rufus/scheduler'
require "uri"
require "open-uri"
require "json"
require "google_image_api"

require_relative "dog/bot"
require_relative "dog/configure"
require_relative "dog/connection"
require_relative "dog/command"

xmpp_connection = Dog::Connection.new(
  method(:say), method(:join), method(:jid)
)

@bot = Dog::Bot.new xmpp_connection

when_ready { @bot.config }
subscription(:request?) { |s| write_to_stream s.approve! }
message(:groupchat?, :body) { |m| @bot.process_group_chat_message m }
message(:chat?, :body) { |m| @bot.process_chat_message m }
