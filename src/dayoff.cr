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

  class Collection(T)
    def initialize(@path : String)
    end

    def get_all : Array(T)
      if File.file? @path
        content = File.read @path
        Array(T).from_json(content)
      else
        [] of T
      end
    end

    def write(items : Array(T))
      content = items.to_json
      File.write @path, content
    end
  end

  class Profile
    PLANNED_DATES = "planned-dates.json"
    WORK_RECORDS  = "work-records.json"

    @pdates = [] of PlannedDate
    @wrecords = [] of WorkRecord

    def initialize(@path : String)
      @pdates = Collection(PlannedDate).new(File.join(@path, PLANNED_DATES)).get_all
      @wrecords = Collection(WorkRecord).new(File.join(@path, WORK_RECORDS)).get_all
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
