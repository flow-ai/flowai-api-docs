FROM ruby:2.5-alpine
EXPOSE 80

RUN apk update \
 && apk add coreutils git make g++ nodejs

RUN git clone https://github.com/lord/slate /slate/source_orig

RUN cd /slate/source_orig && bundle install

VOLUME /slate/source
VOLUME /slate/build

CMD cd /slate && cp -nr source_orig/* source && cd source && exec bundle exec middleman server --watcher-force-polling