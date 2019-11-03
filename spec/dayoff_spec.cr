require "./spec_helper"

describe Dayoff do
  it "can calc work hours" do
    app = Dayoff::App.new
    prof = app.profile("./spec/data")
    prof.get_planned_hours.should eq 20
  end

  it "can calc work hours" do
    app = Dayoff::App.new
    prof = app.profile("./spec/data")
    prof.get_work_hours.should eq 10
  end
end
