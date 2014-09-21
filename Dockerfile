FROM ubuntu:14.04
MAINTAINER Daekwon Kim <propellerheaven@gmail.com>

# Run upgrades
RUN apt-get update
RUN apt-get -qq -y dist-upgrade

# Install basic packages
RUN apt-get -qq -y install git curl build-essential

# Install Ruby 2.0
RUN apt-get -qq -y install software-properties-common
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update
RUN apt-get -qq -y install ruby2.1 ruby2.1-dev
RUN gem install bundler --no-ri --no-rdoc

# Install 
RUN git clone -b master https://github.com/nacyot/slack_notifier.git /app
RUN cd /app; bundle install;

# Run Huboard instance
EXPOSE 4000
WORKDIR /app
CMD bundle exec foreman start -f /app/Procfile
