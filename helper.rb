# -*- coding: utf-8 -*-
require 'rubygems'
require 'bundler/setup'
require 'rack'
require 'sinatra/reloader' if development?
require 'yaml'
require 'json'
require 'kconv'
require 'xmpp4r'
require 'mongoid'
require File.dirname(__FILE__)+'/models/im'

begin
  @@conf = YAML::load open(File.dirname(__FILE__)+'/config.yaml').read
  p @@conf
rescue => e
  STDERR.puts 'config.yaml load error!'
  STDERR.puts e
  exit 1
end

Mongoid.configure{|conf|
  conf.master = Mongo::Connection.new(@@conf['mongo_server'], @@conf['mongo_port']).db(@@conf['mongo_dbname'])
}


def app_root
  "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}"
end

def gtalk_send(message)
  client = Jabber::Client.new(Jabber::JID.new(@@conf['user']))
  client.connect(@@conf['server'], @@conf['port'])
  client.auth(@@conf['pass'])
  
  @@conf['to'].each{|to|
    client.send Jabber::Message.new(to, message.toutf8)
  }
end
