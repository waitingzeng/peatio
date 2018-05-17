FROM ubuntu:xenial
MAINTAINER 171322809@qq.com
RUN sed -i "s/archive.ubuntu./mirrors.aliyun./g" /etc/apt/sources.list

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
RUN apt-get update && apt-get install -y git-core curl zlib1g-dev build-essential \
                     libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 \
                     libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev wget mysql-client  libmysqlclient-dev \
                     build-essential chrpath libssl-dev libxft-dev libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev

RUN git clone git://github.com/sstephenson/rbenv.git ~/.rbenv &&  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc && echo 'eval "$(rbenv init -)"' >> ~/.bashrc && exec $SHELL


RUN git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build && echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc && exec $SHELL

ENV PATH="/root/.rbenv/shims/:${PATH}"


RUN ~/.rbenv/bin/rbenv install 2.2.2 && ~/.rbenv/bin/rbenv global 2.2.2

RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc && /root/.rbenv/versions/2.2.2/bin/gem install bundler && /root/.rbenv/bin/rbenv rehash

RUN apt-get install -y nodejs imagemagick gsfonts
RUN apt-get install -y phantomjs
RUN apt-get install -y screen supervisor vim

#ADD peatio /home/app/peatio
RUN mkdir /peatio
WORKDIR /peatio
ADD peatio/Gemfile /peatio/Gemfile
ADD peatio/Gemfile.lock /peatio/Gemfile.lock

RUN /root/.rbenv/shims/bundle config git.allow_insecure true && /root/.rbenv/shims/bundle install

# RUN ./bin/init_config
RUN apt-get install -y redis-server

ADD conf/supervisord.conf /etc/supervisord.conf
ADD conf/screenrc /etc/screenrc

#RUN bundle exec rake daemons:start

# Clean up APT when done.
#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
