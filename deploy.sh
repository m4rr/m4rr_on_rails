#!/bin/bash
SECONDS=0
echo 'SSH connecting...';\
ssh -o "StrictHostKeyChecking no" m4rr@178.62.208.97 -p 1123 "cd m4rr_ru_on_rails;\
echo 'SSH connected';\
cd ~/m4rr_ru_on_rails;\
git pull;\
bundle --without development test;\
rake routes;\
rake db:migrate;\
rake --quiet assets:clobber;\
rake --quiet assets:precompile;\
touch tmp/restart.txt;\
echo 'curl...';\
curl --silent -I https://m4rr.ru | grep Status;\
echo 'exitting...';\
exit"
duration=$SECONDS
echo "Done in $(($duration)) seconds."

# sudo nano /etc/nginx/sites-available/rails
# sudo nginx -s reload
