source :rubygems

gem 'rails'

gem 'mongoid', :git => 'git://github.com/mongoid/mongoid.git'
gem 'bson_ext'

# Building the tree-structure of majors
gem 'mongoid-ancestry', :git => 'git://github.com/skyeagle/mongoid-ancestry'

# Managing user sessions/remembering them
gem 'devise'

group :useful do
  gem 'heroku'

  # OpenID URLs are huge
  gem 'mongrel', '>= 1.2.0.pre2'
end

gem 'paste', :git => 'git://github.com/alexcrichton/paste.git'
gem 'compass'
gem 'cancan'

# Parsing the course list from CMU's SOC
gem 'nokogiri'

# Parsing scheduleman ics feeds
gem 'ri_cal'

# OAuth/OpenID Login
gem 'oa-oauth'
gem 'oa-openid'

# Pagination
gem 'kaminari'

group :production do
  # Memcache client
  gem 'dalli'
end
