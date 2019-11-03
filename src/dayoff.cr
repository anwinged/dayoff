require "json"

module Dayoff
  VERSION = "0.1.0"

  class PlannedDate
    JSON.mapping(
      date: String,
      hours: Int32,
    )
  end

  class WorkRecord
    JSON.mapping(
      start: String,
      finish: String,
    )
  end

  class Profile
    PLANNED_DATES = "planned-dates.json"
    WORK_RECORDS  = "work-records.json"

    def initialize(@path : String)
      content = File.open(File.join(@path, PLANNED_DATES)) do |file|
        file.gets_to_end
      end
      @pdates = Array(PlannedDate).from_json(content)

      content = File.open(File.join(@path, WORK_RECORDS)) do |file|
        file.gets_to_end
      end
      @wrecords = Array(WorkRecord).from_json(content)
    end

    def get_planned_hours
      sum = 0
      @pdates.each do |wd|
        sum += wd.hours
      end
      sum
    end

    def get_work_hours
      sum = 0
      location = Time::Location.load("Europe/Moscow")
      @wrecords.each do |wr|
        s = Time.parse(wr.start, "%Y-%m-%d %H:%M:%S", location)
        f = Time.parse(wr.finish, "%Y-%m-%d %H:%M:%S", location)
        diff = f - s
        sum += diff.total_hours.to_i32
      end
      sum
    end
  end

  class App
    def profile(path)
      Profile.new(path)
    end
  end
end
