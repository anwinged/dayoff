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

def date_status(profile, date)
  span = profile.date_status date
  {
    date:    date.to_s("%Y-%m-%d"),
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
  rem_span = profile.remaining_time now
  data = {
    started: profile.started?,
    total:   {
      status:  rem_span < Time::Span.zero ? STATUS_OVERTIME : STATUS_UPTIME,
      hours:   rem_span.abs.total_hours.to_i32,
      minutes: rem_span.abs.minutes.to_i32,
    },
    today: date_status(profile, now),
  }
  env.response.content_type = "application/json"
  data.to_json
end

get "/" do
  render "public/index.ecr"
end

Kemal.run
