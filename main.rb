get '/' do
  @title = @@conf['title']
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
  IM.desc(:time).limit(40).map{|i|i.to_hash}.to_json
end
