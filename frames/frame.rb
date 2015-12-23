require 'json'

module PriFrutas
  module FrameSupport

    @csv_data = nil
    @csv_header = nil

    def say_hi
      puts "hi PriFrutas::FrameSupport"
    end

    def to_csv
      if not @csv_data
        csv_build_data
      end
      return @csv_data
    end

    def get_csv_header
      if not @csv_header
        csv_build_data
      end
      return @csv_header
    end

    private
    def csv_build_data
      s = self.to_json.to_s
      s = s.gsub(":", "").gsub("{", "").gsub("}", "").gsub('"', "").split(",")
      aheader = []
      adata = []
      s.each do |d|
        data = d.split("=>")
        aheader << data[0]
        adata << data[1]
      end
      @csv_data = adata.join(";")
      @csv_header = aheader.join(";")
    end
  end
end