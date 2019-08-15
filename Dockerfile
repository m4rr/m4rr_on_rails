# FROM ruby:2.6
# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# ENV RAILS_ROOT /var/www/app_name
# RUN mkdir -p $RAILS_ROOT

# ENV RAILS_ENV production
# ENV RAILS_LOG_TO_STDOUT true
# ENV RAILS_SERVE_STATIC_FILES true


# WORKDIR $RAILS_ROOT

# COPY Gemfile Gemfile
# COPY Gemfile.lock Gemfile.lock
# RUN bundle install --jobs 20 --retry 5 --without development test

# COPY . .

# RUN bundle exec rake assets:precompile

# EXPOSE 3000
# #CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
# #CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

FROM ruby:2.6.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN mkdir /myapp
RUN mkdir /tmp/sockets

WORKDIR /myapp

ADD Gemfile /myapp/Gemfile

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

RUN bundle install --without development test

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

# RUN bundle exec rake routes
# RUN bundle exec rake db:migrate
# RUN bundle exec rake --quiet assets:clobber
# RUN bundle exec rake --quiet assets:precompile

ADD . /myapp