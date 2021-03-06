# ReishiTea
Rails 4 demo app which facilitates the purchase and shipping of the world's most delicious Reishi tea.

-------------------------------------------------------------------------------

* run `bundle install`
* set environment variable for `secret_key_base:` in secrets.yml
* set environment variables for DBMS credentials, and run db init commands
* set environment varialbes for Pusher ( `http://KEY:SECRET@api.pusherapp.com/apps/APP_ID` )

Secrets
-------

Add the following environment params to configure the application:

    export REISHITEA_DEV_SECRET_KEY_BASE=YOUR_APP_SECRET
    export REISHITEA_TEST_SECRET_KEY_BASE=YOUR_APP_SECRET

Database
--------

Set environment variables for DB schema, user, and password, as stated in config/database.yml  
Example:  

    export DEV_MYSQL_DB_USER=myusername
    export DEV_MYSQL_DB_PASS=mypassphrase

Prepare with the following commands:

    ./bin/rake db:create
    ./bin/rake db:migrate

Pusher
------

This application uses [https://pusher.com/](Pusher) for real time updates. Create a free Pusher account, then export
the following environment params to configure the application's Pusher publish/subscribe features:  

    export PUSHER_KEY=YOUR_KEY
    export PUSHER_SECRET=YOUR_SECRET
    export PUSHER_APPID=YOUR_APP_ID
    export PUSHER_URL=http://YOUR_KEY:YOUR_SECRET@api.pusherapp.com/apps/YOUR_APP_ID


-------------------------------------------------------------------------------

Tasks
-----

Emulate Order placement and shipping with the following rake tasks:

    ./bin/rake buynship:order
    ./bin/rake buynship:ship
    ./bin/rake buynship:emulate

Note: new Orders require 10 seconds to ship.

The `emulate` task will prompt for n-many Orders to make. This will loop through the ordering and shipping routines. 
A recommended value for this task is 10..15 loops. Watch the /orders page for real time updates while this task is 
running.


-------------------------------------------------------------------------------

### Copyleft

Copyright :copyright: 2015 Todd Morningstar | [https:://github.com/stratigos](https:://github.com/stratigos)  
GPLv3 LISENCE - Please see [License File](LICENSE.md)  
