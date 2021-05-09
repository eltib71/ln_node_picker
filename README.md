# Lightning Network Node Picker

Command line tools to help you pick nodes for your Lightning Network node. This takes tools and approaches from different people:

- https://github.com/ajpwahqgbi/lightning-tools
- [beeforbacon1](https://twitter.com/beeforbacon1): [LN talk](https://www.youtube.com/watch?v=qnj-ix45tVw)

## Installation

```ruby
gem install ln_node_picker
```

## Usage


```
ln_node_picker help

ln_node_picker low_fee_routing_diversity \
  0280d41c21ba12e6f9096618e60f622bcbcdbd7426164f98b1db23e0018e8ed518 \
  --channel-graph-file=/path/to/1619521220-describegraph.json \
  --base-fee=1010 \
  --per-million-fee=75
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eltib71/ln_node_picker.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
