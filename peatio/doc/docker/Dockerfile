FROM ubuntu:xenial
MAINTAINER 171322809@qq.com
RUN sed -i "s/archive.ubuntu./mirrors.aliyun./g" /etc/apt/sources.list

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

RUN apt-get update && apt-get install -y git-core curl zlib1g-dev build-essential \
                     libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 \
                     libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev

RUN cd && git clone git://github.com/sstephenson/rbenv.git .rbenv && echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc && echo 'eval "$(rbenv init -)"' >> ~/.bashrc && exec $SHELL

RUN git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build && echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc && exec $SHELL

RUN apt-get install -y ruby

RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc && gem install bundler

RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y mysql-server  mysql-client  libmysqlclient-dev redis-server

RUN apt-get install -y wget

RUN echo 'deb http://www.rabbitmq.com/debian/ testing main' | tee /etc/apt/sources.list.d/rabbitmq.list
RUN wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y rabbitmq-server

RUN rabbitmq-plugins enable rabbitmq_management
RUN service rabbitmq-server restart
#RUN wget http://127.0.0.1:15672/cli/rabbitmqadmin
#RUN chmod +x rabbitmqadmin
#RUN mv rabbitmqadmin /usr/local/sbin

RUN apt-get install -y build-essential chrpath libssl-dev libxft-dev && apt-get install -y libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev && apt-get -y install phantomjs

RUN apt-get install -y nodejs

RUN apt-get -y install imagemagick gsfonts


USER app
ENV HOME /home/app

ADD peatio /home/app/peatio
RUN chown -R app:app /home/app/peatio

WORKDIR /home/app/peatio
RUN bundle install --without development test --path vendor/bundle

# RUN ./bin/init_config
ADD conf/rails-amqp.yml /home/app/peatio/config/amqp.yml
ADD conf/rails-database.yml /home/app/peatio/config/database.yml
ADD conf/rails-application.yml /home/app/peatio/config/application.yml
ADD conf/nginx-peatio-env.conf /etc/nginx/main.d/peatio-env.conf

USER root

RUN chown -R app:app /home/app/peatio/config

# Clean up APT when done.
#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
