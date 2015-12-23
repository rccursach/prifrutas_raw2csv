require 'bindata'
require_relative 'frame'

module PriFrutas
  class FrameA < BinData::Record
  include PriFrutas::FrameSupport
    endian :little
    uint8 :head_mark
    int8 :id_device
    uint32 :n_frame
    int16 :acc_x
    int16 :acc_y
    int16 :acc_z
    int16 :giro_x
    int16 :giro_y
    int16 :giro_z
    int16 :magn_x
    int16 :magn_y
    int16 :magn_z
    uint32 :imu_time
    uint16 :end_mark
  end
end