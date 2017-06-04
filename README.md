# OmniAuth Okta OAuth2 Strategy

Strategy to authenticate with Okta via OAuth2 in OmniAuth.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-okta'
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install omniauth-okta
```

### OmniAuth

Here's an example for adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :okta, ENV['OKTA_CLIENT_ID'], ENV['OKTA_CLIENT_SECRET']
end
```

### Devise

First define your application id and secret in `config/initializers/devise.rb`.

Configuration options can be passed as the last parameter here as key/value pairs.

```ruby
config.omniauth :okta, 'OKTA_CLIENT_ID', 'OKTA_CLIENT_SECRET', {}
```
or add options like the following:

```ruby
  require 'omniauth-okta'
  config.omniauth(:okta,
                  <OKTA_CLIENT_ID>,
                  <OKTA_CLIENT_SECRET>,
                  :scope => 'openid profile email',
                  :fields => ['profile', 'email'],
                  :strategy_class => OmniAuth::Strategies::Okta)
```

Then add the following to 'config/routes.rb' so the callback routes are defined.

```ruby
devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
```

Make sure your model is omniauthable. Generally this is "/app/models/user.rb"

```ruby
devise :omniauthable, omniauth_providers: [:okta]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
