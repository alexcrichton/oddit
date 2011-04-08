require 'openid/store/filesystem'

Rails.application.config.middleware.use OmniAuth::Builder do
  api_key    = ENV['API_KEY'] || '2299a39eedae4dac0cf2edb0741bcd25'
  app_secret = ENV['APP_SECRET'] || 'a0b890b1d884000ad6505a7b7390c611'

  provider :facebook, api_key, app_secret, :scope => ''
  provider :open_id, OpenID::Store::Filesystem.new(Rails.root.join('tmp').to_s)
end
