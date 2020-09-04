# README

* Ruby version

2.7.1

* System dependencies

PostgreSQL 12.2

* Install library dependencies

These are managed by bundler:

```bash
bundle install
```

* Database creation

```bash
bundle exec rails db:create
bundle exec rails db:migrate
```

To avoid writing `bundle exec` all the time (which means 'use the bundled dependency, not the global version'), install rails globally (with the same version), or alias `rails` to `bundle exec rails` (preferred way).

* Running the Ruby tests

```
bundle exec rspec
```

* Running the server

```
bundle exec rails server
```

Then visit http://localhost:3000

* Contributing

Submit a PR with a description and meaningful commit messages
