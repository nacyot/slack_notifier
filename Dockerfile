FROM ubuntu:12.04
MAINTAINER Daekwon Kim <propellerheaven@gmail.com>

# Run upgrades
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

# Install basic packages
RUN apt-get -qq -y install git curl build-essential

# Install Ruby 2.0
RUN apt-get -qq -y install python-software-properties
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update
RUN apt-get -qq -y install ruby2.0 ruby2.0-dev
RUN gem install bundler --no-ri --no-rdoc

# Install 
RUN git clone -b master https://github.com/nacyot/slack_notifier.git /app
RUN cd /app; bundle install;

# Run Huboard instance
EXPOSE 4000
CMD bundle exec foreman start -f /app/Procfile
