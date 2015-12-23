#require 'json'
require 'bindata'
require_relative 'frames/frame_a'
require_relative 'frames/frame_b'

module PriFrutas
  class FrameReader

    AA = BinData::Uint8le.new(0xAA)
    BB = BinData::Uint8le.new(0xBB)
    FE = BinData::Uint8le.new(0xFE)

    def read_frames_from_file raw_file

      unless raw_file.is_a? String
        puts "Needs filename string, given: #{raw_file.class.to_s}"
        return nil
      end

      puts "loading raw data into memory..."
      s = File.open(raw_file, 'rb'){ |io| io.read }
      s = s.unpack('C*').to_a

      packages = []
      buff = []


      last = nil
      last_last = nil
      invalids = 0
      l = []

      aas = 0
      bbs = 0

      puts "Traversing data..."
      s.each_index do |i|

        buff << s[i] 
        
        if s[i] == FE and s[i-1] == FE and
          [AA,BB].include? buff[0] and
          ([AA,BB].include? s[i+1] or ([30,40].include? buff.length and i+1 == s.length ))

          if buff.last == FE and (buff.first == AA or buff.first == BB)
            buff_c = buff.pack('C*')
            pac = nil
            if buff.first == AA
              begin
                pac = PriFrutas::FrameA.read(buff_c)
              rescue
                puts "Error  parsing an A frame at byte #{i}"
              end
            elsif buff.first == BB
              begin
                pac = PriFrutas::FrameB.read(buff_c)
              rescue
                puts "Error  parsing a B frame at byte #{i}"
              end
            end 

            unless pac.nil?
              packages << pac
            end
            #l << buff.length
            
            #if buff.first == AA then aas += 1 end; if buff.first == BB then bbs += 1 end
          else
            puts "Invalid found! #{buff.to_s}"
            invalids += 1
          end

          buff = []
        end
      end #each_index
      return packages
    end #

  end #class
end #module