# -*- coding: utf-8 -*-
get '/' do
  @title = @@conf['title']
  haml :index
end

post '/' do
  @message = params['message']
  begin
    gtalk_send @message
    status 200
    @mes = @message
  rescue => e
    STDERR.puts e
    status 300
    @mes = 'error'
  end
end
