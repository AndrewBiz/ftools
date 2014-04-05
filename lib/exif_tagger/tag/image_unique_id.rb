#!/usr/bin/env ruby
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'tag'

module ExifTagger
  module Tag
    # ImageUniqueID, String
    class ImageUniqueId < Tag
      MAX_BYTESIZE = 32 # no limit in EXIF spec
      EXIFTOOL_TAGS = %w(ImageUniqueID)

      def initialize(value_raw = [])
        super(value_raw.to_s)
      end

      def to_write_script
        str = ''
        str << %Q{-ImageUniqueID=#{@value}\n} unless @value.empty?
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
