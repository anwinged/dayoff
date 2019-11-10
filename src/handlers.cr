class CheckProfileHandler < Kemal::Handler
  QUERY_PARAM  = "profile_id"
  HEADER_PARAM = "X-Dayoff-Profile-Id"

  def initialize(@app : Dayoff::App)
  end

  def call(env)
    path = env.request.path
    if /^\/api/.match(path)
      profile_id = get_profile_id env
      if @app.profile? profile_id
        env.set "profile_id", profile_id.to_s
        call_next(env)
      else
        env.response.status_code = 403
        env.response.print "Forbidden"
        env.response.close
      end
    else
      call_next(env)
    end
  end

  private def get_profile_id(env) : Dayoff::ProfileId
    profile_id = env.params.query[QUERY_PARAM]? ||
                 env.request.headers[HEADER_PARAM]? || ""
    Dayoff::ProfileId.new profile_id.strip
  end
end
