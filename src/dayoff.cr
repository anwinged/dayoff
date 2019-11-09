require "kemal"
require "./dayoff/**"
require "./handlers"

base_path = ENV["BASE_PATH"]

puts "Set storage base path: " + base_path

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

get "/api/status" do |env|
  profile = app.profile Dayoff::ProfileId.new(env.get("profile_id").to_s)
  rem_span = profile.remaining_time now
  data = Dayoff::StatusResponse.new(profile.started?, rem_span)
  env.response.content_type = "application/json"
  data.to_json
end

get "/" do
  render "public/index.ecr"
end

Kemal.run
