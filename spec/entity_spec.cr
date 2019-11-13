require "./spec_helper"

module Dayoff::Test
  extend self

  describe "can check same date" do
    planned_date = PlannedDate.new(t(1, 12), 8)
    date = t(1, 20)
    res = planned_date.same_date? date
    res.should be_true
  end
end
