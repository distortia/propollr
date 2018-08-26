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
EXPOSE 4004
ENV PORT=4004 MIX_ENV=prod

ADD . .

# Run frontend build, compile, and digest assets
RUN mix do deps.get, deps.compile && \
    cd assets/ && \
    gem install bundler rubygems-bundler sass --no-rdoc --no-ri && \
    npm install && \
    npm run build && \
    cd - && \
    mix do compile, phx.digest

CMD ["mix", "phx.server"]
