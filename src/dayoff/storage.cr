require "json"

module Dayoff
  abstract class Storage
    macro st_abstract_def(name, dtype)
      abstract def get_{{name}} : Array({{dtype}})
      abstract def set_{{name}}(items : Array({{dtype}}))
    end

    st_abstract_def(planned_dates, PlannedDate)
    st_abstract_def(work_records, WorkRecord)
  end

  class MemoryStorage < Storage
    macro st_memory_def(name, dtype)
      @{{name}} = [] of {{dtype}}

      def get_{{name}} : Array({{dtype}})
        @{{name}}
      end

      def set_{{name}}(items : Array({{dtype}}))
        @{{name}} = items
      end
    end

    st_memory_def(planned_dates, PlannedDate)
    st_memory_def(work_records, WorkRecord)
  end

  class FileStorage < Storage
    def initialize(@path : String)
    end

    macro st_file_def(name, dtype, file)
      @{{name}} = [] of {{dtype}}

      def get_{{name}} : Array({{dtype}})
        fname = File.join(@path, {{file}})
        if File.exists? fname
          content = File.read(fname)
          Array({{dtype}}).from_json content
        else
          [] of {{dtype}}
        end
      end

      def set_{{name}}(items : Array({{dtype}}))
        fname = File.join(@path, {{file}})
        content = items.to_pretty_json
        File.write fname, content
      end
    end

    st_file_def(planned_dates, PlannedDate, "planned-dates.json")
    st_file_def(work_records, WorkRecord, "work-records.json")
  end
end
