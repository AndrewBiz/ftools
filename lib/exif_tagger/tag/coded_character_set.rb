#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (c) ANB Andrew Bizyaev

require_relative 'tag'

module ExifTagger
  module Tag
    # -IPTC:CodedCharacterSet, string[0,32]!
    class CodedCharacterSet < Tag
      MAX_BYTESIZE = 32

      def initialize(value_raw = '')
        super(value_raw.to_s)
      end

      def to_write_script
        str = ''
        str << %Q{-IPTC:CodedCharacterSet=UTF8\n}
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
