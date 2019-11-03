require "./spec_helper"

describe Dayoff do
  it "can calc work hours" do
    app = Dayoff::App.new("./spec/data/planned-dates.json")
    app.get_work_hours.should eq 20
  end
end
