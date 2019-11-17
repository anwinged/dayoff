require "./spec_helper"

module Dayoff::Test
  extend self

  def create_profile
    storage = MemoryStorage.new
    storage.set_planned_dates [
      PlannedDate.new(d(1), 8),
      PlannedDate.new(d(2), 8),
      PlannedDate.new(d(3), 8),
    ]
    storage.set_work_records [
      WorkRecord.new(t(1, 10), t(1, 20)),
      WorkRecord.new(t(2, 10), t(2, 20)),
    ]
    Profile.new(storage)
  end

  describe Profile do
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
      records.last.finish.should eq finish_time
    end

    it "not start twice" do
      prof = create_profile
      start_time = t(3, 10, 0)
      prof.start start_time
      expect_raises(AlreadyStarted) do
        prof.start start_time
      end
    end

    it "not finish twice" do
      prof = create_profile
      start_time = t(3, 10, 0)
      finish_time = t(3, 20, 0)
      prof.start start_time
      prof.finish finish_time
      expect_raises(StartedRecordNotFound) do
        prof.finish finish_time
      end
    end

    it "can calc remaining time" do
      prof = create_profile
      span = prof.remaining_time t(3, 12)
      expected = 8 * 3 - 10 * 2
      expected.should eq span.total_hours
    end

    it "can calc diff on concrete date" do
      prof = create_profile
      span = prof.date_status t(1, 15)
      span.total_hours.should eq 3
    end
  end
end
