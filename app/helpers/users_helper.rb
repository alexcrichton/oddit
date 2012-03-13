module UsersHelper

  def build_cache majors, user = @user
    user.preload_courses!
    @cache = {}
    majors.each{ |m| @cache[m] = m.satisfy_requirements(user) }
  end

  def twitter_url user = @user
    'http://twitter.com/share?' + {
      :url => permalink_url(user),
      :text => "My plan for CMU: "
    }.to_query
  end

  def facebook_url user = @user
    'http://www.facebook.com/sharer.php?' + {
      :u => permalink_url(user),
      :t => "#{user.display_name}'s plan for CMU | Oddit"
    }.to_query
  end

  def reqs_satisfied_by course, user = @user
    @cache.map { |major, req_cache|
      req_cache.map { |req, ids| ids.include?(course) ? req.id : nil }.compact
    }.flatten
  end

end
