FROM ruby:3.1.2-slim-buster

ENV APP=/app
ENV GEMS_PATH=/usr/local/bundle/gems/

RUN apt-get update
RUN apt-get install -y default-libmysqlclient-dev libpq-dev build-essential
RUN apt-get -y install git

RUN mkdir $APP
WORKDIR $APP
ADD Gemfile /app/Gemfile

RUN \
  gem update --system --quiet && \
  gem install bundler -v '~> 2.3'
ENV BUNDLER_VERSION 2.3

ADD Gemfile.lock /app/Gemfile.lock

RUN bundler install && bundle update
RUN bundle update rails

RUN apt-get update \
  && apt-get install -y sudo

RUN adduser --disabled-password --gecos '' app \
  && adduser app sudo \
  && usermod -a -G sudo app \
  && echo '%app ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers 

RUN sudo chown -R app:app $APP
RUN sudo chown -R app:app $GEMS_PATH

ENV LANG en_US.UTF-8

COPY . $APP

USER app
CMD /bin/bash
