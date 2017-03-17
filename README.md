# fluent-plugin-moogaiops

This GEM will add an output plugin for Moog AIOps.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fluent-plugin-moogaiops'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-moogaiops

## Usage

Example matcher to add to your fulend.conf

```
<match system.** *.access.* error.**>
  @type moogaiops
  uri https://<YOUR MOOGAIOPS>.moogsoft.com/events/generic_generic1
  auth <YOUR USER>:<YOUR PASSWORD>
  sourcetype fluentd
  location london
  severity 3
</match>
```
 *uri*
 Is the published endpoint accepting fluent events see your integrations and select the fluent tile to install.

 *auth*
 Is the username and password provided by Moogaiops when you install the REST connector for fluent

 *sourcetype*
 Some text to define the manager attribute in the event

 *location*
 Some text to identify the agent_location in the events

 *severity*
 A default severity (0-5) for the events produced by this matcher

The Gem will also add the **hostname** where the matcher is running and some other default information. The *tag* will be used to populate the **class** and **type**, all three are used in the signature.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/moog-stephen/fluent-plugin-moogaiops.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
