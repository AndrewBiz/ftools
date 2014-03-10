#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'tag'

module ExifTagger
  module Tag
    # NMG:Copyright, string[0,128]
    #   = EXIF:Copyright IPTC:CopyrightNotice XMP-dc:Rights
    class Copyright < Tag
      MAX_BYTESIZE = 128

      def initialize(value_raw = '')
        super(value_raw.to_s)
      end

      def to_write_script
        str = ''
        str << %Q{-MWG:Copyright=#{@value}\n} unless @value.empty?
        str
      end

      private

      def validate
        bsize = @value.bytesize
        if bsize > MAX_BYTESIZE
          @errors << %{#{tag_name}: '#{@value}' } +
                     %{is #{bsize - MAX_BYTESIZE} bytes longer than allowed #{MAX_BYTESIZE}}
          @value_invalid << @value
          @value = ''
        end
      end
    end
  end
end
