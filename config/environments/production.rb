Oddit::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server? (Apache or nginx will already do this)
  config.serve_static_assets = true # for heroku

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Fall back to assets pipeline if a precompiled asset is missed?
  config.assets.compile = true # for heroku

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  config.assets.manifest = Rails.root.join('tmp/assets')

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store
  config.cache_store = :dalli_store

  # Enable static asset server for heroku
  # config.serve_static_assets = true

  # When precompiling, precompile all js/css
  # config.assets.precompile.push(/\w+\.(?:js|css).*/)

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.force_ssl = false # Turn to true when we have certs

  config.action_mailer.default_url_options = { :host => 'oddit.me' }
end
