FROM ruby:2.5-alpine
EXPOSE 80

RUN apk update \
 && apk add coreutils git make g++ nodejs

RUN git clone https://github.com/flow-ai/flowai-api-docs /slate/source_orig

RUN cd /slate/source_orig && bundle install

VOLUME /slate/source
VOLUME /slate/build

CMD touch /tmp/healthy && cd /slate && touch /tmp/healthy && cp -nr source_orig/* source && cd source && exec bundle exec middleman server -p 80 --watcher-force-polling