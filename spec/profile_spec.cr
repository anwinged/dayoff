require "./spec_helper"

module Dayoff::Test
  extend self

  def t(day, hour, min = 0)
    location = Time::Location.load("Europe/Moscow")
    Time.local(2019, 1, day, hour, min, location: location)
  end

  describe Profile do
    it "can calc work hours" do
      storage = MemoryStorage.new
      storage.set_work_records [
        WorkRecord.new(t(1, 10), t(1, 20)),
      ]
      prof = Profile.new(storage)
      prof.get_work_hours.should eq 10
    end

    it "can write new record" do
      storage = MemoryStorage.new
      storage.set_work_records [
        WorkRecord.new(t(1, 10), t(1, 20)),
      ]
      prof = Profile.new(storage)
      start_time = t(2, 10)
      prof.start start_time
      records = storage.get_work_records
      records.size.should eq 2
      records.last.finish.should be_nil
    end

    it "can finish started record" do
      storage = MemoryStorage.new
      storage.set_work_records [
        WorkRecord.new(t(1, 10), t(1, 20)),
        WorkRecord.new(t(2, 10), nil),
      ]
      prof = Profile.new(storage)
      finish_time = t(2, 20)
      prof.finish finish_time
      records = storage.get_work_records
      records.size.should eq 2
      records.last.finish_time.should eq finish_time
    end
  end
end
