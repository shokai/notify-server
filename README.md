Notify Server
=============
http ---> (IM, RSS, JSON)


Clone
-----

    % git clone git://github.com/shokai/notify-server.git
    % cd notify-server


Dependencies
------------

- Ruby 1.8.7
- MongoDB 1.8+


Install Dependencies
--------------------

    % gem install bundler
    % bundle install
    

Config
------

    % cp sample.config.yaml config.yaml

edit config.yaml.


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
