# Jrq

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jrq'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jrq

## Usage

- sample JSON data
  - AWS ip-ranges.json
  - CloudFormation Template
  - ECS Task Definition
  - JSON Schema / Swagger

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec jrq` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Build & Push to rubygems.org

    $ gem build jrq.gemspec

then

    $ gem install jrq-x.y.z.gem

or

    $ gem push jrq-x.y.z.gem

### Plan

- color
- launch REPL when STDIN isn't given
  - jrq foo.json => also launch REPL
- (maybe) _ -> j ?

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/jrq.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
