# README

[![Build Status](https://travis-ci.org/ServiceInnovationLab/pancake-backend.svg?branch=dev)](https://travis-ci.org/ServiceInnovationLab/pancake-backend)
[![Maintainability](https://api.codeclimate.com/v1/badges/87a2101f7a74f5a28320/maintainability)](https://codeclimate.com/github/ServiceInnovationLab/pancake-backend/maintainability)
[![AwesomeCode Status for ServiceInnovationLab/pancake-backend](https://awesomecode.io/projects/61fa3b06-4025-4829-ad9d-568b2967bdd8/status)](https://awesomecode.io/projects/81)
[![Test Coverage](https://api.codeclimate.com/v1/badges/87a2101f7a74f5a28320/test_coverage)](https://codeclimate.com/github/ServiceInnovationLab/pancake-backend/test_coverage)

[![Waffle.io - Columns and their card count](https://badge.waffle.io/ServiceInnovationLab/pancake-frontend.svg?columns=all)](https://waffle.io/ServiceInnovationLab/pancake-frontend)


Serverside Rates Rebate processor.

Production server = https://ratesrebates.services.govt.nz

Installation
============

To set up a development environment
-----------------------------------

This is an app built using Json API suite https://jsonapi-suite.github.io/jsonapi_suite/concepts


1. make your own fork, and clone
  `git clone [repo]`

1. `cd pancake-backend`

1. Set up environment variables
  `cp env-example .env`

You will need ruby, the bundler gem to install dependencies. We recommend managing your ruby with a tool like rbenv or rvm

Install the dependencies

```
bundle install
yarn install
```

You will need a database. Any database supported by ruby on rails / jsonapi suite should work, but we only support Postgresql. Configure your database url in your `.env`, then:

```
bundle exec rake db:create db:migrate
```

To run the server:

```
bundle exec rails s
```

Seed the database and create a user:

```
bundle exec rake db:seed
```

This will pop up an invitation email for `juanvandenanker@gmail.com` in your browser. If the server is running you will be able to click the link to accept the invitation and set your password.

To run the tests
----------------

```
bundle exec rspec
```

Test coverage report is at `coverage/index.html`
