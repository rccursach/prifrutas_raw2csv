#!/usr/bin/env ruby

require_relative 'frame_reader'
require_relative 'frames/frame_a'
require_relative 'frames/frame_b'

split_files = true
output_a = 'dataframes_a.csv'
output_b = 'dataframes_b.csv'
output_joined = 'dataframes.csv'
input_file = nil

## check args

if ARGV.length == 0 or ARGV[0] == '-h' or ARGV[0] == '--help'
  puts "Usage:"
  puts "ruby raw2csv.rb filename.raw [--aout=filename.csv] [--bout=filename.csv]"
  puts "ruby raw2csv.rb filename.raw --join [--out=filename.csv]"
  puts ""
  puts "[] are optional"
  puts "If no --aout or --bout is specified, the names will be #{output_a} and #{output_b}"
  puts "If --join with no --out, the output file will be #{output_joined}"
  puts ""
  exit 0
end

ARGV.each do |s|
  if s =~ /^(--)([a-z])\w+(=([a-z]\w+))?/
    if s == '--join'
      split_files = false
      next
    elsif s.start_with? "--out="
      output_joined = s.split("=")[1]
      next
    elsif s.start_with? "--aout="
      output_a = s.split("=")[1]
      next
    elsif s.start_with? "--bout="
      output_b = s.split("=")[1]
      next
    end
  else
    input_file = s
    next
  end
end

## check for input file existence

if input_file.nil?
  puts "Need an input file!!"
  puts "see ruby raw2csv.rb -h for usage instructions"
  exit 1
end

if not File.file? input_file
  puts "#{input_file} doesn't exists or is not a file"
  exit 1
end

## open file and get packages
puts "Loading raw file..."
fr = PriFrutas::FrameReader.new
frames = fr.read_frames_from_file(input_file)
afirst = true
bfirst = true


## process frames
puts "Converting and writing into file(s)..."
if split_files
  ## process in both files
  fa = File.open(output_a, "w")
  fb = File.open(output_b, "w")
  frames.each do |f|
    if f.is_a? PriFrutas::FrameA
      if afirst then fa.puts f.get_csv_header; afirst=false end
      fa.puts f.to_csv
    elsif f.is_a? PriFrutas::FrameB
      if bfirst then fb.puts f.get_csv_header; bfirst=false end
      fb.puts f.to_csv
    end
  end
  fa.close; fb.close
  puts "Frames saved in #{output_a} and #{output_b}"
else
  ## process in just one
  file = File.open(output_joined, "w")
  frames.each do |f|
    file.puts f.to_csv
  end
  file.close
  puts "Frames saved in #{output_joined}"
end
