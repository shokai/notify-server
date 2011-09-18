# -*- coding: utf-8 -*-

before do
  @title = @@conf['title']
  @description = @@conf['description']
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

get '/json' do
  content_type 'application/json'
  make_json IM.desc(:time).limit(@@conf['feed_max_size'])
end

get '/rss' do
  content_type 'application/xml'
  rss = make_rss IM.desc(:time).limit(@@conf['feed_max_size'])
  rss.to_s
end

get '/search/*.json' do
  content_type 'application/json'
  @word = params[:splat].first
  make_json IM.where(:message => /#{@word}/).desc(:time).limit(@@conf['feed_max_size'])
end

get '/search/*.rss' do
  content_type 'application/xml'
  @word = params[:splat].first
  @messages = IM.where(:message => /#{@word}/).desc(:time).limit(@@conf['feed_max_size'])
  rss = make_rss(@messages, "#{@@conf['title']} - search:#{@word}")
  rss.to_s
end

get '/search/*' do
  @word = params[:splat].first
  @per_page = params[:per_page].to_i
  @per_page = @@conf['feed_max_size'] if @per_page < 1
  @page = params[:page].to_i
  @page = 1 if @page < 1
  @title = "#{@@conf['title']} - search:#{@word}"
  ims = IM.where(:message => /#{@word}/).desc(:time)
  @ims_count = ims.count
  @ims = ims.skip((@page-1)*@per_page).limit(@per_page)
  haml :search
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
