# Cortera

This gem provides a ruby client to the Cortera JSON API.

## Installation

Add this line to your application's Gemfile:

    gem 'cortera'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cortera

## Authentication

The Cortera REST Connect API requires a Cortera developer account. Get in touch with [Cortera](https://start.cortera.com/developer/dispatcher/contactUs "Contact Cortera") if you need an account.

## Usage

1. Configure a client instance
```ruby
client = Cortera::Client.new do |config|
  config.username    = ENV['CORTERA_USERNAME']
  config.password    = ENV['CORTERA_PASSWORD']
end
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/cortera/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
