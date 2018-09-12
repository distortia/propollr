#!/usr/local/bin/bash

mix deps.get --only prod
mix phx.digest.clean
MIX_ENV=prod PORT=4001 mix compile
cd assets && npm run deploy
cd ../
mix phx.digest

echo -e "🎉🎉🎉 \e[1;36mEverything is setup! Please Commit the Changes!\e[0m 🎉🎉🎉"