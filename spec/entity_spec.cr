require "./spec_helper"

module Dayoff::Test
  extend self

  it "planned can calc in range" do
    planned_date = PlannedDate.new(t(1, 12), 8)
    t1 = t(1, 0)
    t2 = t(2, 0)
    res = planned_date.in_range t1, t2
    res.total_hours.should eq 8
  end

  it "planned can calc in range 2" do
    planned_date = PlannedDate.new(t(3, 0), 8)
    t1 = t(1, 0)
    t2 = t(2, 0)
    res = planned_date.in_range t1, t2
    res.total_hours.should eq 0
  end

  it "planned can calc in range 2" do
    planned_date = PlannedDate.new(d(1), 8)
    t1 = t(1, 0).at_beginning_of_day
    t2 = t(1, 0).at_end_of_day
    res = planned_date.in_range t1, t2
    res.total_hours.should eq 8
  end

  it "worked can calc in range" do
    work_record = WorkRecord.new(t(1, 10), t(1, 20))
    t1 = t(1, 15).at_beginning_of_day
    t2 = t(1, 15)
    res = work_record.in_range t1, t2
    res.total_hours.should eq 5
  end

  it "worked can calc in range 2" do
    work_record = WorkRecord.new(t(1, 10), t(1, 20))
    t1 = t(2, 15).at_beginning_of_day
    t2 = t(2, 15)
    res = work_record.in_range t1, t2
    res.total_hours.should eq 0
  end
end
