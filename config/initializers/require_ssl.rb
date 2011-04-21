class RequireSSL
  def initialize app
    @app = app
  end

  def call env
    req = ActionDispatch::Request.new env

    if req.ssl?
      @app.call env
    else
      Rack::Response.new.tap do |resp|
        resp.redirect "https://" + req.host + req.fullpath
      end.finish
    end
  end

end

unless Rails.env.development?
  Rails.application.middleware.insert_after ActionDispatch::Static, RequireSSL
end
