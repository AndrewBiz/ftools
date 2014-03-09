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
        # TODO: value = value_raw.each { |k, v| value_raw[k] = v.to_s } 
        super
      end

      def to_write_script
        str = ''
        if @errors.empty?
          str << %Q{-GPSLatitude="#{@value[:gps_latitude]}"\n}
          str << %Q{-GPSLatitudeRef=#{@value[:gps_latitude_ref]}\n}
          str << %Q{-GPSLongitude="#{@value[:gps_longitude]}"\n}
          str << %Q{-GPSLongitudeRef=#{@value[:gps_longitude_ref]}\n}
          str << %Q{-GPSAltitude=#{@value[:gps_altitude]}\n}
          str << %Q{-GPSAltitudeRef=#{@value[:gps_altitude_ref]}\n}
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
