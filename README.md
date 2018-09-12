# Propollr

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Move back up one directory with `cd ../`
  * Seed the database if you have not done so with `mix run priv/repo/seeds.exs`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).


# Notes

* PSQL GCloud
  * Main Acct:
    * user: propollrpsql
    * pass: K0Fd1DJ8GwFKlFOa
  * Default Acct:
    * user: postgres
    * pass: K0Fd1DJ8GwFKlFOa


# Prod

Your machine:

Run `bin/prod_setup.sh`

or

```
$ mix deps.get --only prod
$ MIX_ENV=prod PORT=4001 mix compile

# Compile assets
$ npm run deploy

$ mix phx.digest

$ git add .
$ git commit -m <Your Message>
$ git push
```

On the server:


To run:
```
$ git pull
$ ps ax | grep beam
$ sudo kill <pid>
$ sudo MIX_ENV=prod PORT=80 elixir --detached --sname propollr --cookie propollr -S mix do compile, phx.server
```

To connect to the running server:
```
iex --sname local --cookie propollr --remsh propollr@propollr
```