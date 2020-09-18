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

* Glossary

Robert C. Martin says in Clean Code that you shouldn't try and be clever-clever with naming (with puns or other jokes). It's inconsiderate to people with different cultural or linguistic backgrounds, for one thing, and you'll forget what you were referring to when you return to the code in a year, for another.

However, as this is a side-project I am doing partly for fun, I'm going to take this opportunity to use some perfectly cromulent words I enjoy that don't see the daylight *that* much. I particularly like oligosyllabic ones. Hence this glossary.

[draught](https://en.wiktionary.org/wiki/draft#English): Noun for an act of drinking, used for the Player-Cup join model. (Chose old-fashioned spelling to distinguish from 'draft'.)
[quaff](https://en.wiktionary.org/wiki/quaff): Verb for drink. Method name.
[quorate](https://en.wiktionary.org/wiki/quorate#English): Adjective for when the correct number of people are present. 
