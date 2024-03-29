# Waste Exemptions Engine

![Build Status](https://github.com/DEFRA/waste-exemptions-engine/workflows/CI/badge.svg?branch=main)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_waste-exemptions-engine&metric=sqale_rating)](https://sonarcloud.io/dashboard?id=DEFRA_waste-exemptions-engine)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_waste-exemptions-engine&metric=coverage)](https://sonarcloud.io/dashboard?id=DEFRA_waste-exemptions-engine)
[![Licence](https://img.shields.io/badge/Licence-OGLv3-blue.svg)](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3)

A Rails Engine for the [Waste Exemptions](https://github.com/DEFRA/waste-exemptions) digital service.

## Prerequisites

Make sure you already have:

- Ruby 3.2.2
- [Bundler](http://bundler.io/) – for installing Ruby gems
- PostgreSql

## Mounting the engine

Add the engine to your Gemfile:

```
gem "waste_exemptions_engine",
    git: "https://github.com/DEFRA/waste-exemptions-engine"
```

Install it with `bundle install`.

Then mount the engine in your routes.rb file:

```
Rails.application.routes.draw do
  mount WasteExemptionsEngine::Engine => "/"
end
```

The engine should now be mounted at the root of your project. You can change `"/"` to a different route if you'd prefer it to be in a subdirectory.

## Installation

You don't need to do this if you're just mounting the engine without making any changes.

However, if you want to edit the engine, you'll have to install it locally.

Clone the repo and drop into the project:

```bash
git clone https://github.com/DEFRA/waste-exemptions-engine.git && cd waste-exemptions-engine
```

Then install the dependencies with `bundle install`.

## Testing the engine

The engine is mounted in a dummy Rails 7 app (in /spec/dummy) so we can properly test its behaviour.

The test suite is written in RSpec.

To run all the tests, use:

`bundle exec rspec`

# Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at:

http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3

The following attribution statement MUST be cited in your products and applications when using this information.

> Contains public sector information licensed under the Open Government license v3

### About the license

The Open Government Licence (OGL) was developed by the Controller of Her Majesty's Stationery Office (HMSO) to enable information providers in the public sector to license the use and re-use of their information under a common open licence.

It is designed to encourage use and re-use of information freely and flexibly, with only a few conditions.
