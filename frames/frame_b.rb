require 'bindata'
require_relative 'frame'

module PriFrutas
  class FrameB < BinData::Record
  include PriFrutas::FrameSupport
    endian :little
    uint8 :head_mark
    int8 :id_device
    uint32 :n_frame
    float_le :temp1
    float_le :temp2
    float_le :temp3
    float_le :hum
    uint16 :press0
    uint16 :press1
    float_le :weight
    uint32 :time_rtc
    uint16 :batt_status_1
    uint16 :batt_status_2
    uint16 :end_mark
  end
end
