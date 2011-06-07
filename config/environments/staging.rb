# Inherit all production settings
require File.expand_path('../production', __FILE__)

Oddit::Application.configure do
  # Don't wanna have to bother with dalli in staging
  config.cache_store = :memory_store

  # Handling SSL in staging is just annoying
  config.force_ssl = false
end
