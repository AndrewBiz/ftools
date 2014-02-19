#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'tag'

module ExifTagger
  module Tag
    # NMG:Copyright, ???string[0,32]+, String
    #   = EXIF:Copyright IPTC:CopyrightNotice XMP-dc:Rights
    class Copyright < Tag
      MAX_BYTESIZE = 128 # TODO: what size

      def initialize(value_raw = [])
        super(value_raw.to_s)
      end

      def to_write_script
        str = ''
        @value.each do |o|
          # -MWG:Copyright=2013 (c) Andrey Bizyaev. All Rights Reserved.
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
