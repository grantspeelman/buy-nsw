# buy.nsw

A new digital procurement platform for the NSW Government.

## Technical documentation

This is a Ruby on Rails application which contains functionality for external
and internal users.

### Dependencies

- [Ruby](https://www.ruby-lang.org/) – currently 2.5.0 (as defined in `.ruby-version`)
- [Bundler](https://bundler.io/) – install with `gem install bundler`
- [Yarn](https://yarnpkg.com/) – for assets. On a Mac, install with `brew install yarn`
- [PostgreSQL](https://www.postgresql.org/) – On a Mac, use [Postgres.app](https://postgresapp.com))
- [ChromeDriver](http://chromedriver.chromium.org/) and Chrome – for running feature tests. On a Mac, install with
Caskroom: `brew cask install chromedriver`
- [MailCatcher](https://mailcatcher.me/) (optional) – for receiving emails in development. Install with
`gem install mailcatcher`
- [ClamAV](https://www.clamav.net/) - used for virus scanning of uploaded documents

### Setting up the application

If you are running the application for the first time, run `bin/setup` to
install Ruby dependencies and initialize the database.

The application configuration in the development environment, including database
names, is defined in `.env.development`, and loaded automatically in dev.

### Running the application

`foreman start`

The app will launch by default at `http://localhost:5000`. (If you configure
Foreman differently, the port may change.)

### Running the test suite

`bin/rake`

This will run:

- the RSpec test suite (in `/spec`)
- an RCov coverage report, which will be saved to `coverage/`

### Sending emails in development

To receive emails in development, use [MailCatcher](https://mailcatcher.me). It
runs an SMTP server which catches emails and displays it in a web interface.

Install MailCatcher with `gem install mailcatcher`, then run `mailcatcher` in
your console to start the server. Don't commit it to the Gemfile, as it causes
conflicts.

## Deployment to production

The app is a standard [12 factor app](https://12factor.net/) that should be possible to install on many platforms. It has been successfully
installed on [Heroku](https://www.heroku.com/) and [Elastic Beanstalk on Amazon Web Services (AWS)](https://aws.amazon.com/elasticbeanstalk/).

There is some configuration for Elastic Beanstalk in `.ebextensions` and `.elasticbeanstalk`.

## Continuous integration

We have been using [CircleCI](https://circleci.com/) to run automated tests and deployment
to staging. You will find an example configuration in `.circleci`.

## How the application works

Documentation explaining the application architecture is available in the `docs` directory of this repo.

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
