require "spec"
require "../src/dayoff/**"

def d(day)
  location = Time::Location.load("Europe/Moscow")
  Time.local(2019, 1, day, location: location)
end

def t(day, hour, min = 0)
  location = Time::Location.load("Europe/Moscow")
  Time.local(2019, 1, day, hour, min, location: location)
end

def with_temp_dir(&block)
  tmpdir = File.tempname("dayoff_file_storage")
  Dir.mkdir tmpdir
  begin
    yield tmpdir
  ensure
    Dir.glob(tmpdir + "/*") do |f|
      File.delete f
    end
    Dir.rmdir tmpdir
  end
end
