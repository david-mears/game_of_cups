# README

* Ruby version

2.7.1

* Node version

I appear to be on nodejs 14.5.0, but others probably work too. Duncan was prompted to install 13.7.

* System dependencies

PostgreSQL 12.2
Redis 5.0.8

* Install library dependencies

These are managed by bundler and yarn:

```bash
bundle install
yarn install
```

* Database creation

The 'proper' way:

```bash
bundle exec rails db:create
bundle exec rails db:migrate
```

The shortcut which doesn't run the migrations but just creates the database based on the schema:

```bash
bundle exec rails db:setup
```

To avoid writing `bundle exec` all the time (which means 'use the bundled dependency, not the global version'), install rails globally (with the same version), or alias `rails` to `bundle exec rails` (preferred way).

* Running the Ruby tests

```
bundle exec rspec
```

* Lint Ruby

```
rubocop -a
```

* Running the server

```
bundle exec rails server
```

Then visit http://localhost:3000

* Contributing

Submit a PR with a description and meaningful commit messages
