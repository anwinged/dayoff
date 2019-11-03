require "json"

module Dayoff
  VERSION = "0.1.0"

  class PlannedDate
    JSON.mapping(
      date: String,
      hours: Int32,
    )
  end

  class App
    def initialize(pddates_path)
      content = File.open(pddates_path) do |file|
        file.gets_to_end
      end
      @pdates = Array(PlannedDate).from_json(content)
    end

    def get_work_hours
      sum = 0
      @pdates.each do |wd|
        sum += wd.hours
      end
      sum
    end
  end
end
