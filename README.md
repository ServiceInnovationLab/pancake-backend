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

1. make your own fork, and clone
  `git clone [repo]`

1. `cd pancake-backend`

1. Add project upstream
  `git remote add upstream git@github.com:WhareHauora/pancake-backend.git`

1. Set up environment variables
  `cp env-example .env`

1. `bundle install`

1. `bundle exec rake db:create db:migrate`

1. `bundle exec rails s`
