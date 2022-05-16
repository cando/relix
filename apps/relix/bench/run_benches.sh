#!/bin/bash
export MIX_ENV=bench

docker-compose up -d db
sleep 5
mix setup

elixir --erl "+P 2000000" -S mix run bench/recipes_bench.exs