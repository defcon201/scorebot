FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /scorebot
WORKDIR /scorebot
ADD Gemfile /scorebot/Gemfile
ADD Gemfile.lock /scorebot/Gemfile.lock
RUN bundle install
ADD . /scorebot
