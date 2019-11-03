require "json"

module Dayoff
  VERSION = "0.1.0"

  class WorkDate
    JSON.mapping(
      date: String,
      hours: Int32,
    )
  end

  class App
    def initialize(wh_path)
      content = File.open(wh_path) do |file|
        file.gets_to_end
      end
      @wdates = Array(WorkDate).from_json(content)
    end

    def get_work_hours
      sum = 0
      @wdates.each do |wd|
        sum += wd.hours
      end
      sum
    end
  end
end
