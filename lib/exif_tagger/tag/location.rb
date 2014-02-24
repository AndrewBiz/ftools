#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'tag'

module ExifTagger
  module Tag
    # MWG:Location, String
    #   = IPTC:Sub-location + XMP-iptcCore:Location 
    #   + XMP-iptcExt:LocationShownSublocation
    class Location < Tag
      MAX_BYTESIZE = 64

      def initialize(value_raw = [])
        super(value_raw.to_s)
      end

      def to_write_script
        str = ''
        @value.each do |o|
          # -MWG:Location=Вавилова 23
          # str << %Q{-MWG:Keywords-=#{o}\n}
          # str << %Q{-MWG:Keywords+=#{o}\n}
        end
        str
      end

      private

      def validate
        bsize = @value.bytesize
        if bsize > MAX_BYTESIZE
          @errors << %{#{tag_name}: '#{v}' } +
                     %{is #{bsize - MAX_BYTESIZE} bytes longer than allowed #{MAX_BYTESIZE}}
          @value_invalid << v
          @value = ''
        end
      end
    end
  end
end
