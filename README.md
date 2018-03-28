# OmniAuth Okta OAuth2 Strategy

Strategy to authenticate with Okta via OAuth2 in OmniAuth.

This strategy uses Okta's OpenID Connect API with OAuth2. See their [developer docs](https://developer.okta.com/docs/api/resources/oidc.html) for more details.

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
  provider :okta, ENV['OKTA_CLIENT_ID'], ENV['OKTA_CLIENT_SECRET'], {
    client_options: {
      site:          'https://your-org.okta.com',
      authorize_url: 'https://your-org.okta.com/oauth2/v1/authorize',
      token_url:     'https://your-org.okta.com/oauth2/v1/token'
    }
  }
end
```

### Devise

First define your application id and secret in `config/initializers/devise.rb`.

Configuration options can be passed as the last parameter here as key/value pairs.

```ruby
config.omniauth :okta, ENV['OKTA_CLIENT_ID'], ENV['OKTA_CLIENT_SECRET'], {}
```
or add options like the following:

```ruby
  require 'omniauth-okta'
  config.omniauth(:okta,
                  ENV['OKTA_CLIENT_ID'],
                  ENV['OKTA_CLIENT_SECRET'],
                  :scope => 'openid profile email',
                  :fields => ['profile', 'email'],
                  :client_options => {
                    :site =>          'https://your-org.okta.com',
                    :authorize_url => 'https://your-org.okta.com/oauth2/v1/authorize',
                    :token_url =>     'https://your-org.okta.com/oauth2/v1/token'
                  }
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

## Auth Hash

Here's an example of an authentication hash available in the callback by accessing `request.env['omniauth.auth']`:

```ruby
{
  "provider" => "okta",
  "uid" => "0000000000000001",
  "info" => {
    "name" => "John Smith",
    "email" => "john@example.com",
    "first_name" => "John",
    "last_name" => "Smith",
    "image" => "https://photohosting.com/john.jpg"
  },
  "credentials" => {
    "token" => "TOKEN",
    "expires_at" => 1496617411,
    "expires" => true
  },
  "extra" => {
    "raw_info" => {
      "sub" => "0000000000000001",
      "name" => "John Smith",
      "locale" => "en-US",
      "email" => "john@example.com",
      "picture" => "https://photohosting.com/john.jpg",
      "website" => "https://example.com",
      "preferred_username" => "john@example.com",
      "given_name" => "John",
      "family_name" => "Smith",
      "zoneinfo" => "America/Los_Angeles",
      "updated_at" => 1496611646,
      "email_verified" => true
    },
    "id_token" => "TOKEN",
    "id_info" => {
      "ver" => 1,
      "jti" => "AT.D2sslkfjdsldjf899n090sldkfj",
      "iss" => "https://your-org.okta.com",
      "aud" => "https://your-org.okta.com",
      "sub" => "john@example.com",
      "iat" => 1496613811,
      "exp" => 1496617411,
      "cid" => "CLIENT_ID",
      "uid" => "0000000000000001",
      "scp" => ["email", "profile", "openid"]
    }
  }
}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

