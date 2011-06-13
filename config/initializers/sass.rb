Rails.application.config.after_initialize do
  compass_path = Gem.loaded_specs['compass'].full_gem_path
  config = Rails.application.config
  config.sass.load_paths << "#{compass_path}/frameworks/compass/stylesheets"
  config.sass.load_paths << "#{compass_path}/frameworks/blueprint/stylesheets"

  compass = config.compass
  compass.images_dir = 'app/assets/images'
  compass.css_dir    = 'app/assets/stylesheets'
  compass.fonts_dir  = 'app/assets/fonts'
  compass.http_images_path      = '/assets'
  compass.http_fonts_path       = '/assets'
  compass.http_stylesheets_path = '/assets'
  compass.http_javascripts_path = '/assets'

  compass.asset_cache_buster :none
end
