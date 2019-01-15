FROM ruby:2.6.0
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get update -qq \
  && apt-get install -y build-essential libpq-dev nodejs npm
RUN mkdir /laa-great-ideas
WORKDIR /laa-great-ideas
COPY Gemfile /laa-great-ideas/Gemfile
COPY Gemfile.lock /laa-great-ideas/Gemfile.lock
RUN bundle install && npm install
COPY . /laa-great-ideas
