# -*- coding: utf-8 -*-
require 'rubygems'
require 'bundler/setup'
require 'rack'
require 'sinatra/reloader' if development?
require 'yaml'
require 'json'
require 'kconv'
require 'xmpp4r'
require 'rss/maker'
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

def make_rss(im_items, title=@@conf['title'])
  rss = RSS::Maker.make('2.0') do |rss|
    rss.channel.about = app_root+'/rss'
    rss.channel.title = title
    rss.channel.description = title
    rss.channel.link = app_root
    rss.items.do_sort = true
    rss.items.max_size = @@conf['feed_max_size']
    
    im_items.each{|im|
      i= rss.items.new_item
      i.title = im.message
      i.link = "#{app_root}/im/#{im._id}"
      i.description = "#{im.message}"
      i.date = Time.at im.time
    }
  end
  rss
end

def make_json(im_items)
  im_items.map{|i|i.to_hash}.to_json
end
