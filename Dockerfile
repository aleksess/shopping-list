FROM ruby:3.3.5-slim


COPY ./ ./

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config


RUN bundle install

EXPOSE 4567

CMD ["ruby", "main.rb"]
