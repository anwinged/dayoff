require "kemal"
require "./dayoff/**"

module Dayoff
  VERSION = "0.1.0"

  class App
    def profile(profile_id : ProfileId)
      Profile.new(profile_id.to_s)
    end
  end
end

get "/" do
  "Hello World!"
end

Kemal.run
