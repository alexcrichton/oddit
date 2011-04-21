# Be sure to restart your server when you modify this file.

opts = {:key => '_audit_man_session'}
unless Rails.env.development?
  opts[:secure] = true
end

AuditMan::Application.config.session_store :cookie_store, opts

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# AuditMan::Application.config.session_store :active_record_store
