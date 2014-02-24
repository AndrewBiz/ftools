#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'tag'

module ExifTagger
  module Tag
    # GPS tags are used for camera location according to MWG 2.0)
    # GPSLatitude (rational64u[3])
    # GPSLatitudeRef (string[2] 'N' = North, 'S' = South)
    # GPSLongitude (rational64u[3])
    # GPSLongitudeRef (string[2] 'E' = East, 'W' = West)
    # GPSAltitude (rational64u)
    # GPSAltitudeRef (int8u 0 = Above Sea Level, 1 = Below Sea Level)
    class GpsCreated < Tag
      def initialize(value_raw = {})
        super(value_raw.each { |k, v| value_raw[k] = v.to_s })
      end

      def to_write_script
        str = ''
        @value.each do |o|
          # gps_latitude: "55 36 31.49" #GPSLatitude
          # gps_latitude_ref: N  #GPSLatitudeRef
          # gps_longitude: "37 43 28.27" #GPSLongitude
          # gps_longitude_ref: E #GPSLongitudeRef
          # gps_altitude: "170.0" #GPSAltitude
          # gps_altitude_ref: "Above Sea Level" #GPSAltitudeRef
          # -GPSLatitude=" 55 41 49.51"
          # -GPSLatitudeRef=N
          # -GPSLongitude=" 37°34 23.61"
          # -GPSLongitudeRef=E
          # -GPSAltitude=131.0
          # -GPSAltitudeRef=Above Sea Level
          # str << %Q{-MWG:Keywords-=#{o}\n}
          # str << %Q{-MWG:Keywords+=#{o}\n}
        end
        str
      end

      private

      def validate
        @value.each do |k, v|
          # @errors << %{#{tag_name}: '#{v}' } +
          #           %{is #{bsize - MAX_BYTESIZE} bytes longer than allowed #{MAX_BYTESIZE}}
          # @value_invalid << v
          # @value = {}
        end
      end
    end
  end
end
