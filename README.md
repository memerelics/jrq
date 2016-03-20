# jrq

jrq is a CLI JSON processor for Rubyists. jrq enable you to filter/map/reduce JSON without studying new syntax.

```
$ echo '{"foo": [1, 2, 3], "bar": 100 }' \
  | jrq '_.foo.reduce(&:+) * _.bar' # => 600
```

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

JSON data from STDIN will be parsed and passed as `_` variable. Because jrq just evaling given string in the context of Ruby, actually it's almost same as doing like `cat a.json | ruby -rjson -e "JSON.load(STDIN)['foo']"`. Here are some samples below:

`_` is a Hash, so `_.keys` would be nice place to start with.

```
$ aws ec2 describe-instances \
  | jrq '_.keys'
[
  "Reservations"
]
```

jrq parses given JSON with [Hashie::Mash](https://github.com/intridea/hashie#mash), so you can access json fields with dot(`.`) like Ruby's method access.

```
$ aws ec2 describe-instances \
  | jrq '_.Reservations.class'
Array
```

Then digging deeper...

```
$ aws ec2 describe-instances \
  | jrq -r '_.Reservations.map{|r| r.keys }.flatten.uniq'
[
  "OwnerId",
  "ReservationId",
  "Groups",
  "Instances",
  "RequesterId"
]
```

... to get information you need.

```
$ aws ec2 describe-instances \
  | jrq 'ins = _.Reservations.first.Instances.first;
        [ins.InstanceId, ins.VpcId, ins.SubnetId, ins.PrivateIpAddress]'
[
  "i-aaaaaaaa",
  "vpc-5dxxxxx8",
  "subnet-a1xxxxx6",
  "172.31.25.92"
]
```

```
$ aws ec2 describe-instances \
  | jrq '_.Reservations.map{|r| r.Instances.map{|i| i.InstanceId } }.flatten'
[
  "i-aaaaaaaa",
  "i-bbbbbbbb",
  "i-cccccccc",
  "i-dddddddd",
]
```

With `-r` or `--raw` option, raw output would be displayed. It's suitable for passing to another program as input.

```
$ aws ec2 describe-instances \
  | jrq -r '_.Reservations.map{|r| r.Instances.map{|i| i.InstanceId } }.flatten'
i-aaaaaaaa
i-bbbbbbbb
i-cccccccc
i-dddddddd
```

You can even require another Ruby library.

```
$ curl -s https://ip-ranges.amazonaws.com/ip-ranges.json \
  | jrq 'require "ipaddr"; _.prefixes.select{|p| p.region == "ap-northeast-1" }.map{|p| IPAddr.new(p.ip_prefix).to_i.to_s(2) }'

[
  "11011000000000000000000000000",
  "101110001100111110000000000000",
  "110100010001000000000000000000",
  "110100010111000011110000000000",
  "110100010111000101000000000000",
  ...
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec jrq` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Build & Push to rubygems.org

    $ gem build jrq.gemspec

then

    $ gem install jrq-x.y.z.gem

or

    $ gem push jrq-x.y.z.gem

### Plan & TODOs

- color
- launch REPL when STDIN isn't given
  - jrq foo.json => also launch REPL

- prepare sample JSON data
  - AWS ip-ranges.json
  - CloudFormation Template
  - ECS Task Definition
  - JSON Schema / Swagger

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/memerelics/jrq/issues

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
