source :rubygems

gem 'rails', '3.2.2'

gem 'bson_ext'
gem 'mongoid'

# Building the tree-structure of majors
gem 'mongoid-ancestry', :git => 'git://github.com/skyeagle/mongoid-ancestry'

# Managing user sessions/remembering them
gem 'devise'

group :useful do
  gem 'heroku'
  gem 'mongrel', '>= 1.2.0.pre2' # OpenID URLs are huge
end

group :assets do
  gem 'jquery-rails'
  gem 'compass', '>= 0.12.alpha.0'
  gem 'sass-rails', '~> 3.2.0'
  gem 'coffee-rails', '~> 3.2.0'
  gem 'uglifier'
end

gem 'cancan'

# Parsing the course list from CMU's SOC
gem 'nokogiri', :require => false

# Parsing scheduleman ics feeds
gem 'ri_cal'

# OAuth/OpenID Login
gem 'omniauth-facebook'
gem 'omniauth-openid'

# Pagination
gem 'kaminari'

group :production do
  # Memcache client
  gem 'dalli'
  gem 'thin'
end
