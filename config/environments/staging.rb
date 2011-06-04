# Inherit all production settings
require File.expand_path('../production', __FILE__)

AuditMan::Application.configure do
  config.cache_store = :memory_store
end
