FROM alpine:3.4

ENV APP_DIR=/usr/app

RUN apk update && apk upgrade && \
    apk add ruby ruby-io-console ruby-bundler ruby-irb ruby-bigdecimal tzdata mysql-dev && \
    apk add nodejs

RUN mkdir -p $APP_DIR
WORKDIR $APP_DIR

# Cache bundle install
COPY Gemfile Gemfile.lock $APP_DIR/

RUN apk add --virtual build-dependencies curl-dev ruby-dev build-base && \
    cd $APP_DIR; bundle install --without development test -j4 && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/*

COPY . $APP_DIR


# OpenShift specific permissions for tmp
RUN bundle exec rake tmp:create
RUN chgrp -R 0 tmp
RUN chmod -R g+rw tmp
RUN find tmp -type d -exec chmod g+x {} +

RUN bundle exec rake assets:precompile

# Publish port 8080
EXPOSE 8080
