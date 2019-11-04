require "./spec_helper"

module Dayoff::Test
  describe Storage do
    it "can store data in file" do
      with_temp_dir do |tmpdir|
        storage = FileStorage.new tmpdir
        storage.set_planned_dates [
          PlannedDate.new(d(1), 8),
          PlannedDate.new(d(1), 8),
        ]
        entries = Dir.glob(tmpdir + "/*")
        1.should eq entries.size
      end
    end
  end
end
