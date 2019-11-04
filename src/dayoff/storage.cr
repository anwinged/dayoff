require "json"

module Dayoff
  abstract class Storage
    abstract def get_planned_dates : Array(PlannedDate)
    abstract def set_planned_dates(items : Array(PlannedDate))
    abstract def get_work_records : Array(WorkRecord)
    abstract def set_work_records(items : Array(WorkRecord))
  end

  class MemoryStorage < Storage
    @planned_dates = [] of PlannedDate
    @work_records = [] of WorkRecord

    def get_planned_dates : Array(PlannedDate)
      @planned_dates
    end

    def set_planned_dates(items : Array(PlannedDate))
      @planned_dates = items
    end

    def get_work_records : Array(WorkRecord)
      @work_records
    end

    def set_work_records(items : Array(WorkRecord))
      @work_records = items
    end
  end
end
