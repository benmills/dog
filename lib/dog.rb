require "rubygems"
require "blather/client/client"
require 'rufus/scheduler'
require "uri"
require "open-uri"
require "json"
require "google_image_api"

require_relative "dog/bot"
require_relative "dog/configure"
require_relative "dog/connection"
require_relative "dog/command"

xmpp_client = Blather::Client.setup "dog@localhost", "test"
xmpp_connection = Dog::Connection.new xmpp_client

@bot = Dog::Bot.new xmpp_connection

xmpp_client.register_handler(:ready) { @bot.config }
xmpp_client.register_handler(:message, :chat?, :body) { |m| @bot.process_chat_message m }
xmpp_client.register_handler(:message, :groupchat?, :body) { |m| @bot.process_group_chat_message m }

EM.run { xmpp_client.run }
