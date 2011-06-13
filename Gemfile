source :rubygems

gem 'rails', '3.1.0.rc4'

gem 'mongoid', :git => 'git://github.com/mongoid/mongoid.git'
gem 'bson_ext'

# Building the tree-structure of majors
gem 'mongoid-ancestry', :git => 'git://github.com/skyeagle/mongoid-ancestry'

# Managing user sessions/remembering them
gem 'devise'

group :useful do
  gem 'heroku'
  gem 'mongrel', '>= 1.2.0.pre2' # OpenID URLs are huge
end

gem 'jquery-rails'
gem 'compass'
gem 'sass-rails', :git => 'git://github.com/rails/sass-rails'
gem 'coffee-script'
gem 'cancan'

# Parsing the course list from CMU's SOC
gem 'nokogiri', :require => false

# Parsing scheduleman ics feeds
gem 'ri_cal'

# OAuth/OpenID Login
gem 'oa-oauth'
gem 'oa-openid'

# Pagination
gem 'kaminari'

group :production, :staging do
  gem 'uglifier'
end

group :production do
  # Memcache client
  gem 'dalli'

  gem 'therubyracer-heroku', '0.8.1.pre3'
end