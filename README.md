IM Server
=========
send xmpp/jabber.


Clone
-----

    % git clone git://github.com/shokai/im-server.git
    % cd im-server


Install Dependencies
--------------------

    % gem install bundler
    % bundle install
    

Run
---

    % ruby development.ru

open [http://localhost:8126](http://localhost:8126)


API
---

post

    % curl -d 'message=hello' http://localhost:8126/

get 

- http://localhost:8126/rss
- http://localhost:8126/json
- http://localhost:8126/search/*.rss
- http://localhost:8126/search/*.json


Deploy
------
use Passenger with "config.ru"
