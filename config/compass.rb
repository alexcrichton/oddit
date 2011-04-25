# This configuration file works with both the Compass command line tool and within Rails.
# Require any additional compass plugins here.
project_type = :rails
project_path = Compass::AppIntegration::Rails.root

# # Set this to the root of your project when deployed:
http_path       = '/'
css_dir         = 'public/stylesheets'
sass_dir        = 'app/stylesheets'
images_dir      = 'public/images'
javascripts_dir = 'public/javascripts'
environment     = Compass::AppIntegration::Rails.env

# # To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true

if Rails.env.production?
  output_style = :compressed
  css_dir      = 'tmp/stylesheets'
end

require 'compass/sass_extensions/sprites/base'

module AuditMan::CompassHack
  def filename
    if Rails.env.production?
      Rails.root.join('tmp/images')
    else
      super
    end
  end
end

Compass::SassExtensions::Sprites::Base.class_eval {
  include AuditMan::CompassHack
}
