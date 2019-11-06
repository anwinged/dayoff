module Dayoff
  class CrossedTimeSpan < Exception
  end

  class StartedRecordNotFound < Exception
  end

  class AlreadyStarted < Exception
  end
end
