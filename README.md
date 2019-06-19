# HTTP Rest Client

A simple HTTP API Client built on top of
[http.rb](https://github.com/httprb/http).

## About

The library represents a thin wrapper (~100 lines of code) over the wonderful
`http.rb` gem, allowing you to define and interact with a RESTful API in an
Active Mapper style.

Main goals:
 * No _magic_ please
 * Clean and simple DSL
 * Less code, less maintenance
 * Good docs and test coverage
 * Keep it up-to-date (or at least tell people this is no longer maintained)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'http_rest_client'
```

And then execute:

```ruby
$ bundle
```

Or install it yourself as:

```ruby
$ gem install http_rest_client
```

## Usage


## Development

After checking out the repo, run `bundle` to install dependencies.

Then, run `rake` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/stas/http_rest_client. This project is intended to be
a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting with this project codebase, issue
tracker, chat rooms and mailing list is expected to follow the [code of
conduct](https://github.com/[USERNAME]/active_record_pgcrypto/blob/master/CODE_OF_CONDUCT.md).
