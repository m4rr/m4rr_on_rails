git pull
bundle --without development test
rake routes
rake db:migrate
rake assets:clobber
rake assets:precompile
touch tmp/restart.txt

# sudo nano /etc/nginx/sites-available/rails
# sudo nginx -s reload
