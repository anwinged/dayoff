require "./spec_helper"

describe Dayoff do
  it "can calc work hours" do
    app = Dayoff::App.new(
      "./spec/data/planned-dates.json",
      "./spec/data/work-records.json",
    )
    app.get_planned_hours.should eq 20
  end

  it "can calc work hours" do
    app = Dayoff::App.new(
      "./spec/data/planned-dates.json",
      "./spec/data/work-records.json",
    )
    app.get_work_hours.should eq 10
  end
end
