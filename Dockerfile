# Dockerfile
FROM albertc/alpine-elixir-phoenix:latest

RUN apk update && apk upgrade &&\
    apk --no-cache add ruby \
    ruby-dev \
    ruby-bundler \
    postgresql-client\
    python \
    python-dev \
    py-pip \
    build-base \
    alpine-sdk \
    libffi-dev \
  && pip install virtualenv \
  && rm -rf /var/cache/apk/*

# Set exposed ports
EXPOSE 4000
ENV PORT=4000 MIX_ENV=dev

ADD . .

# Get dependencies
RUN mix do deps.get, deps.compile

# Create, migrate, and seed  DB
RUN mix ecto.create && mix ecto.migrate &&\
    cd assets && npm install && \
    cd ../ && \
    mix run priv/repo/seeds.exs

CMD ["mix", "phx.server"]
