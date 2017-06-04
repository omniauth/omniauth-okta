# Omniauth::Okta
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'omniauth-okta'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install omniauth-okta
```

Add to your devise.rb initializer in the following way:

```ruby
  require 'omniauth-okta'
  config.omniauth(:okta,
                  <CLIENT_ID>,
                  <CLIENT_SECRET>,
                  :scope => 'openid profile email',
                  :fields => ['profile', 'email'],
                  :strategy_class => Omniauth::Strategies::Okta)
```

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
