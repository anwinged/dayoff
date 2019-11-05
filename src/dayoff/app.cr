module Dayoff
  class App
    def initialize(@base_path : String)
    end

    def profile?(profile_id : ProfileId) : Bool
      Dir.exists? File.join(@base_path, profile_id.to_s)
    end

    def profile(profile_id : ProfileId) : Profile
      storage = FileStorage.new File.join(@base_path, profile_id.to_s)
      Profile.new(storage)
    end
  end
end
