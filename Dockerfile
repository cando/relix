# ./Dockerfile

FROM elixir:latest

RUN apt-get update && \
    apt-get install -y postgresql-client

RUN mix local.hex --force

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN mix do compile

CMD ["/app/entrypoint.sh"]