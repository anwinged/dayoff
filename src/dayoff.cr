require "kemal"
require "./dayoff/**"
require "./handlers"

base_path = ENV["BASE_PATH"]

puts "Set storage base path: " + base_path

STATUS_UPTIME   = "uptime"
STATUS_OVERTIME = "overtime"

app = Dayoff::App.new base_path

add_handler CheckProfileHandler.new(app)

def now
  Time.local(Time::Location.load("Europe/Moscow"))
end

def serialize_span(span : Time::Span)
  {
    status:  span < Time::Span.zero ? STATUS_OVERTIME : STATUS_UPTIME,
    hours:   span.abs.total_hours.to_i32,
    minutes: span.abs.minutes.to_i32,
  }
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
  total_span = profile.total_status now
  today_span = profile.date_status now
  data = {
    started: profile.started?,
    total:   {
      time: serialize_span total_span,
    },
    today: {
      date: now.to_s("%Y-%m-%d"),
      time: serialize_span today_span,
    },
  }
  env.response.content_type = "application/json"
  data.to_json
end

get "/" do
  render "public/index.ecr"
end

Kemal.run
