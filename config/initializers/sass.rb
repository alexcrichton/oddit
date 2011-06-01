Rails.application.config.after_initialize do
  Sass::Engine::DEFAULT_OPTIONS[:load_paths].tap do |load_paths|
    compass = Gem.loaded_specs['compass'].full_gem_path
    load_paths.push *Rails.application.assets.paths
    load_paths << "#{compass}/frameworks/compass/stylesheets"
    load_paths << "#{compass}/frameworks/blueprint/stylesheets"
  end

  compass = Rails.application.config.compass
  compass.images_dir = 'app/assets/images'
  compass.css_dir    = 'app/assets/stylesheets'
  compass.fonts_dir  = 'app/assets/fonts'
  compass.http_images_path      = '/assets'
  compass.http_fonts_path       = '/assets'
  compass.http_stylesheets_path = '/assets'
  compass.http_javascripts_path = '/assets'

  compass.asset_cache_buster :none
end
