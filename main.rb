# -*- coding: utf-8 -*-

before do
  @title = @@conf['title']
end

get '/' do
  haml :index
end

post '/' do
  @message = params['message']
  @addr = env['REMOTE_ADDR']
  begin
    gtalk_send @message
    im = IM.new(:from => @addr, :message => @message, :time => Time.now.to_i)
    im.save
    status 200
    @mes = @message
  rescue => e
    STDERR.puts e
    status 300
    @mes = 'error'
  end
end

get '/message.json' do
  content_type 'application/json'
  IM.desc(:time).limit(@@conf['feed_max_size']).map{|i|i.to_hash}.to_json
end

get '/rss.xml' do
  content_type 'application/xml'
  rss = RSS::Maker.make('2.0') do |rss|
    rss.channel.about = app_root+'/rss.xml'
    rss.channel.title = @@conf['title']
    rss.channel.description = @@conf['title']
    rss.channel.link = app_root
    rss.items.do_sort = true
    rss.items.max_size = @@conf['feed_max_size']
    
    IM.desc(:time).limit(@@conf['feed_max_size']).each{|im|
      i= rss.items.new_item
      i.title = im.message
      i.link = "#{app_root}/im/#{im._id}"
      i.description = "#{im.message}"
      i.date = Time.at im.time
    }
  end
  rss.to_s
end

get '/im/:id' do
  @id = params[:id]
  begin
    raise 'IM not found' if @id.size < 1
    @im = IM.find(@id)
    haml :im
  rescue => e
    status 300
    @mes = e.to_s
    if e.to_s =~ /not found/ or e.to_s == 'illegal ObjectId format'
      status 404
    end
  end
end
