# Waste Exemptions Engine

![Build Status](https://github.com/DEFRA/waste-exemptions-engine/workflows/CI/badge.svg?branch=main)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_waste-exemptions-engine&metric=sqale_rating)](https://sonarcloud.io/dashboard?id=DEFRA_waste-exemptions-engine)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_waste-exemptions-engine&metric=coverage)](https://sonarcloud.io/dashboard?id=DEFRA_waste-exemptions-engine)
[![Licence](https://img.shields.io/badge/Licence-OGLv3-blue.svg)](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3)

A Rails Engine for the [Waste Exemptions](https://github.com/DEFRA/waste-exemptions) digital service.

## Prerequisites

Make sure you already have:

- Ruby 3.4.6
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

### Legacy vs New data model

The test factories support both the new and legacy data models. In the new data model, registration exemptions are linked to site addresses. By default, factories will create exemptions linked to a site address.

To run tests with the legacy data model (exemptions not linked to addresses), set the `LEGACY_DATA_MODEL` environment variable:

```bash
LEGACY_DATA_MODEL=true bundle exec rspec
```

This is useful when testing against older data structures or during migration periods.

## EA area lookup

Site location checks use the local `ea_public_face_areas` table rather than an external EA area API.
That table is populated from the EA public face area boundary dataset via the back-office `load_admin_areas` task.
The postcode address finder is still an external address lookup; for that route, coordinates come from the address lookup response.
Grid reference to easting/northing conversion is done locally.

For site addresses, the flow is:

1. Get coordinates from the selected address lookup response, or derive them from the submitted grid reference.
2. Query `WasteExemptionsEngine::EaPublicFaceArea` with PostGIS via `DetermineAreaService`.
3. Treat locations with no matching polygon as `Outside England`.
4. If the EA area lookup errors, log and notify Airbrake, but allow the front-office journey to continue.

The front-office England-only restriction is behind the `restrict_site_locations_to_england` feature toggle.

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
