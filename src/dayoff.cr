require "kemal"
require "./dayoff/**"
require "./handlers"

base_path = "./tmp"

app = Dayoff::App.new base_path

add_handler CheckProfileHandler.new(app)

def now
  Time.local(Time::Location.load("Europe/Moscow"))
end

post "/api/start" do |env|
  profile = app.profile Dayoff::ProfileId.new(env.get("profile_id").to_s)
  profile.start now
  env.response.status_code = 201
end

post "/api/finish" do |env|
  profile = app.profile Dayoff::ProfileId.new(env.get("profile_id").to_s)
  profile.finish now
  env.response.status_code = 204
end

get "/api/remaining-time" do |env|
  profile = app.profile Dayoff::ProfileId.new(env.get("profile_id").to_s)
  rem_span = profile.remaining_time now
  data = {
    hours:   rem_span.total_hours.to_i32,
    minutes: rem_span.minutes.to_i32,
  }
  env.response.content_type = "application/json"
  data.to_json
end

Kemal.run
