module UsersHelper

  def build_cache majors, user = @user
    @user.preload_courses!
    @cache = {}
    majors.each{ |m| @cache[m] = m.satisfy_requirements(@user) }
  end

end
