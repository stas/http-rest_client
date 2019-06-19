# HTTP Rest Client

A simple HTTP API Client built on top of
[http.rb](https://github.com/httprb/http). The interface was borrowed from Nestful.

## About

The library represents a thin wrapper (~100 lines of code) over the wonderful
`http.rb` gem, allowing you to define and interact with a RESTful API in an
Active Record style using plain old Ruby objects.

Main goals:
 * No _magic_ please
 * Clean and minimal DSL
 * Less code, less maintenance
 * Good docs and test coverage
 * Keep it up-to-date (or at least tell people this is no longer maintained)

This library exists because similar projects are either:
 * no longer maintained
 * implement features which `http.rb` offers and thus have a higher complexity
 * have other very specific features (like relationships, xml or other flavour
   response types support)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'http-rest_client'
```

And then execute:

```ruby
$ bundle
```

Or install it yourself as:

```ruby
$ gem install http-rest_client
```

## Usage

This library provides composable modules/mixins to allow you build flexible
interfaces/wrappers for RESTful APIs.

### DSL

The `HTTP::RestClient::DSL` mixin provides a couple of helpers to define
the API endpoint, path and content type. It also takes care of the error
handling and the parsing of the responses.

The following class methods are provided by this mixin:
 * `endpoint('http://api.tld')` - sets up the API URI
 * `path('/resource')` - defines the API path of the resource
 * `content_type('application/json')` - sets up the content type of the request
 * `accept('application/json')` - sets up the response media type
 * `basic_auth(user: 'username', pass: 'password')` - sets up the basic
   authentication user and password
 * `auth('AUTH_TOKEN')` - sets up the authentication token
 * `request('get', uri, options)` - creates a request and handles the response

### CRUD

The `HTTP::RestClient::CRUD` mixin provides the _create-read-update-delete_ helpers
to help you define Active Record style classes representing the API resources.

The following class methods are provided by this mixin:
 * `all(params)` - returns all available resources
 * `find(id, params)` - returns the available resource based on the `id`
 * `create(params)` - creates and returns the new resource using the passed data
 * `update(id, params)` - updates and returns the resource using the passed data
 * `delete(id)` - removes the resource

#### Resource definition

Let's take the example below as an API resource we want to work with:
```ruby
require 'ostruct'

class MyResource < OpenStruct
  extend HTTP::RestClient::DSL
  extend HTTP::RestClient::CRUD

  endpoint 'https://httpbin.org'
  path 'anything'
  content_type 'application/json'
  accept 'application/json'
  basic_auth user: 'user1', pass: 'pass1'
  # Alternatively, define the token based authentication
  # auth('MY_API_TOKEN')
end
```
The class inherits the `OpenStruct` interface which allows an easy way to have
dynamic class attributes. And for testing purposes, we will use the HTTPBin
web service to mock any responses.

Now we can operate on the new resource endpoint in a pragmatic way:

```ruby
> res_one = MyResource.create(attr: :attr_value)
> res_one.json
=> {"attr"=>"attr_value"}
> res_one['method']
=> "POST"
```

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
https://github.com/stas/http-rest_client. This project is intended to be
a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting with this project codebase, issue
tracker, chat rooms and mailing list is expected to follow the [code of
conduct](https://github.com/[USERNAME]/active_record_pgcrypto/blob/master/CODE_OF_CONDUCT.md).
