# Procurement Hub

A new digital procurement platform for the NSW Government.

## Technical documentation

This is a Ruby on Rails application which contains functionality for external
and internal users.

### Dependencies

- Ruby – currently 2.5.0 (as defined in `.ruby-version`)
- Bundler – install with `gem install bundler`
- Yarn – for assets. On a Mac, install with `brew install yarn`
- PostgreSQL – On a Mac, use [Postgres.app](https://postgresapp.com))
- ChromeDriver and Chrome – for running feature tests. On a Mac, install with
Caskroom: `brew cask install chromedriver`
- MailCatcher (optional) – for receiving emails in development. Install with
`gem install mailcatcher`

### Setting up the application

If you are running the application for the first time, run `bin/setup` to
install Ruby dependencies and initialize the database.

The application configuration in the development environment, including database
names, is defined in `.env.development`, and loaded automatically in dev.

### Running the application

`foreman start -m web=1`

The app will launch by default at `http://localhost:5000`. (If you configure
Foreman differently, the port may change.)

### Running the test suite

`bin/rake`

This will run:

- the RSpec test suite (in `/spec`)
- an RCov coverage report, which will be saved to `coverage/`

To run tests on file changes:
```
bundle exec guard
```
(To run all tests from the guard console just press return)

### Sending emails in development

To receive emails in development, use [MailCatcher](https://mailcatcher.me). It
runs an SMTP server which catches emails and displays it in a web interface.

Install MailCatcher with `gem install mailcatcher`, then run `mailcatcher` in
your console to start the server. Don't commit it to the Gemfile, as it causes
conflicts.

### Seller onboarding workflow

The seller onboarding flow is a multi-step form, which goes beyond Rails'
typical CRUD-idioms.

In this app, the flow is implemented with the `SellerApplicationPresenter`,
using form objects to model each step. The form objects use the
[Reform](http://trailblazer.to/gems/reform/) gem, part of the
[Trailblazer](http://trailblazer.to) framework. Reform has some intricacies
around dealing with composition (eg. the `Seller` and `SellerApplication`
models) and nested fields, for which overrides are defined in
`Sellers::Applications::BaseForm`.

Each form defines its own validations, which use the
[dry-validation](http://dry-rb.org/gems/dry-validation/) library. No validations
are defined directly on the model, because objects should only be persisted
through a form object.

This is important because:
- we can save an incomplete record (eg. so that a seller can save their
  application and return later).
- we can vary the steps displayed to the user based on the information provided,
  and only validate data corresponding to the steps which are shown.

The forms for the application are defined in `app/forms/sellers/applications/`,
with associated views in `app/views/sellers/applications/`, and most of the form
strings in the `en` locale file.

## AWS Setup

[Install the Elastic Beanstalk CLI](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install.html).
On OS X:
```
brew install awsebcli
```

All commits to `master` are automatically deployed to the staging environment if
the tests pass.

## Promoting a build in staging to production

```
bin/promote-to-production build-nnn
```
## Copyright & Licence

Copyright NSW Department of Finance, Services and Innovation.

Licensed under the [MIT License](LICENCE.md)
